public with sharing class JEOL_ObjectTriggerHadler {

    /**
     *  コメントを内容に格納する。超過分は切り捨てる。
     */
	public static void operationHistory_descriptionToMemo(List<OperationHistory__c> recs) {
        for (OperationHistory__c rec: recs) {
            String memoText = rec.Description__c;
            if (memoText != null && memoText.length() > 255) {
                memoText = memoText.substring(0, 254);
                memoText += '…';
            }
            rec.Memo__c = memoText;
        }
	}
	
    /**
     *  Todoの参照先を設定する。対象は顧客対応表。
     */
    public static void operationHistory_relationshipToSupport(List<OperationHistory__c> recs) {
        Set<String> ccNos = new Set<String>();
        for(OperationHistory__c rec : recs) {
            String ccNo = rec.CallCenterReceptionNo__c;
            if (ccNo != null) {
                ccNos.add(ccNo);
            }
        }

        Map<String, String> supportIdMap = new Map<String, String>();
        for(Support__c rec: [SELECT Id, Name FROM Support__c WHERE Name IN: ccNos]) {
            supportIdMap.put(rec.Name, rec.Id);
        }
        for(OperationHistory__c rec: recs) {
            if(String.isNotBlank(rec.CallCenterReceptionNo__c)) {
                rec.Support__c = supportIdMap.get(rec.CallCenterReceptionNo__c);
            }
        }
    }

    /**
     *  登録された対応履歴をもとに顧客対応表の開始日、終了日を設定する。
     */
    public static void operationHistory_putServiceDateToSupport(List<OperationHistory__c> recs) {
        List<String> ccNos = new List<String>();
        for(OperationHistory__c rec : recs) {
        	String ccNo = rec.CallCenterReceptionNo__c;
        	if (String.isNotBlank(ccNo)) {
	            ccNos.add(ccNo);
        	}
        }

        List<Support__c> supports = [
                SELECT
                     Id, CallCenterUketsukeNo_Sync__c, ServiceStartDate__c, ServiceEndDate__c,
                    (SELECT Id, CorrespondenceNumber__c, Name, StartDatetime__c, EndDatetime__c, Description__c, Status__c From OperationHistries__r)
                FROM
                    Support__c
                    
                WHERE
                    Name IN: ccNos
        ];
        
        List<Support__c> updateTargets = new List<Support__c>();
        for(Support__c supportRec: supports) {
	        Decimal firstCorrespondenceNumber = 1000000000;
	        Decimal secondCorrespondenceNumber = 0;
            for(OperationHistory__c targetRec: supportRec.OperationHistries__r) {
                DateTime startDateTime = targetRec.StartDatetime__c;
                DateTime endDateTime = targetRec.EndDatetime__c;

                if(startDateTime != NULL && endDateTime != NULL) {
                    String subjectText = targetRec.Name;
                    Decimal correspondenceNumber = targetRec.CorrespondenceNumber__c;

                    if(subjectText == '一次' && correspondenceNumber < firstCorrespondenceNumber) {
                        supportRec.ServiceStartDate__c = startDateTime.date();
                        firstCorrespondenceNumber = correspondenceNumber;
                    }

                    if (subjectText == '二次' && correspondenceNumber > secondCorrespondenceNumber) {
                        supportRec.Responce__c = targetRec.Description__c;
                        if(targetRec.Status__c == 'Completed') {
                            supportRec.ServiceEndDate__c = endDateTime.date();
                            secondCorrespondenceNumber = correspondenceNumber;
                        }
                    }
                }
            }
            updateTargets.add(supportRec);
        }
        update updateTargets;
    }
    
    /**
     *  販売オーダが更新されたとき、販売オーダラインを辿った先にある売上げに対して取引先の更新を行う
     */
    public static void salesOrder_AccountReferenceToSalesResult(List<SalesOrder__c> salesOrders) {
        Map<String, SalesOrder__c> idSalesOrderMap = new Map<String, SalesOrder__c>();
        for (SalesOrder__c rec: salesOrders) {
            idSalesOrderMap.put(rec.id, rec);
        }
        
        List<SalesResult__c> salesResults = [SELECT id, shukkasaki__c, seikyusaki__c, hanbaisaki__c, SalesOrder__c FROM SalesResult__c WHERE SalesOrder__c IN: idSalesOrderMap.keySet()];
        if (!salesResults.isEmpty()) {
            for (SalesResult__c rec: salesResults) {
                if (idSalesOrderMap.containsKey(rec.SalesOrder__c)) {
                    SalesOrder__c targetOrder = idSalesOrderMap.get(rec.SalesOrder__c);
                    rec.shukkasaki__c = targetOrder.ShipmentAccount__c;
                    rec.seikyusaki__c = targetOrder.seikyusakiAccount__c;
                    rec.hanbaisaki__c = targetOrder.SalesAccount__c;
                }
            }
            update salesResults;
        }
    }
    /**
     *  受け取った販売オーダラインNo_連携用項目から、売上オブジェクトに各種取引先の参照関係を作成する。
     */
    public static void salesResult_relationshipToAccount(List<SalesResult__c> recs) {
        Set<String> targetOrderIds = new Set<String>();
        for(SalesResult__c rec : recs) {
            String salesOrderId = rec.SalesOrder__c;
            if (String.isNotblank(salesOrderId)) {
                targetOrderIds.add(salesOrderId);
            }
        }
        
        if (!targetOrderIds.isEmpty()) {
            List<SalesOrder__c> orders = [SELECT id, SalesAccount__c, ShipmentAccount__c, seikyusakiAccount__c FROM SalesOrder__c WHERE id =: targetOrderIds];
            Map<String, SalesOrder__c> orderMap = new Map<String, SalesOrder__c>();
            for (SalesOrder__c orderRec: orders) {
                orderMap.put(orderRec.id, orderRec);
            }
            for(SalesResult__c rec: recs) {
                String salesOrderId = rec.SalesOrder__c;
                if(orderMap.containsKey(salesOrderId)) {
                    SalesOrder__c tergetOrder = orderMap.get(salesOrderId);
                    rec.hanbaisaki__c = tergetOrder.SalesAccount__c;
                    rec.shukkasaki__c = tergetOrder.ShipmentAccount__c;
                    rec.seikyusaki__c = tergetOrder.seikyusakiAccount__c;
                }
            }
        }
    }
    
    public static Boolean isServiceOrderControlUpdate = true;
    public static void serviceOrderControl_dateSync(List<ServiceOrderControl__c> recs) {
    	Set<String> condisions = new Set<String>();
    	for (ServiceOrderControl__c rec: recs) {
			String parentIdCondition = ' ServiceOrder__c = \'' + JEOLUtil.escapeNull(rec.ServiceOrder__c) + '\' ';
			String setNoCondition = ' SetNo__c = \'' + JEOLUtil.escapeNull(rec.SetNo__c) + '\' ';
			condisions.add(' ( ' + parentIdCondition + ' AND ' + setNoCondition +' )');
		}
		if (condisions.size() > 0) {
			String queryStr = ' SELECT Id, ServiceOrder__c, SetNo__c, ReturnDate__c, ReturnDueDate__c, RetrieveDate__c FROM ServiceOrderControl__c ';
			queryStr += ' WHERE ' + String.join(new List<String>(condisions), ' OR ');
			List<ServiceOrderControl__c> targetControlRecs = Database.query(queryStr);
			Map<String, List<ServiceOrderControl__c>> controlMap = new Map<String, List<ServiceOrderControl__c>>();
			for (ServiceOrderControl__c rec: targetControlRecs) {
				String serviceOrderId = rec.ServiceOrder__c;
				String setNo = rec.SetNo__c;
				String key = serviceOrderId + '_' + setNo;
				if (!controlMap.containsKey(key)) {
					controlMap.put(key, new List<ServiceOrderControl__c>());
				}
				controlMap.get(key).add(rec);
			}
			List<ServiceOrderControl__c> updateRecs = new List<ServiceOrderControl__c>();
			for (ServiceOrderControl__c rec: recs) {
				String serviceOrderId = rec.ServiceOrder__c;
				String setNo = rec.SetNo__c;
				String key = serviceOrderId + '_' + setNo;
				if (controlMap.containsKey(key)) {
					List<ServiceOrderControl__c> updateTargets = controlMap.get(key);
					for (ServiceOrderControl__c target: updateTargets) {
						if (rec.id != target.Id) {
							target.ReturnDate__c = rec.ReturnDate__c;
							target.ReturnDueDate__c = rec.ReturnDueDate__c;
							target.RetrieveDate__c = rec.RetrieveDate__c;
							updateRecs.add(target);
						}
					}
				}
			}
			isServiceOrderControlUpdate = false;
			update updateRecs;
		}
   }
}