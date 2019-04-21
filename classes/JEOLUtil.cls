public with sharing class JEOLUtil {
    
    public static final String REFERENCE_NAME_AREA = 'Area';                        //地域
    public static final String REFERENCE_NAME_COMPANY_DIVISION = 'CompanyDivision'; //会社区分
    public static final String REFERENCE_NAME_CONTRACT_STATUS = 'ContractState';    //契約更新状況
    public static final String REFERENCE_NAME_COUNTRY = 'Country';                  //国
    public static final String REFERENCE_NAME_DEPARTMENT = 'Department';            //部門
    public static final String REFERENCE_NAME_JAPAN_STATE = 'JapanState';           //都道府県
    public static final String REFERENCE_NAME_ORG_UNIT = 'OrgUnit';                 //企業単位
    public static final String REFERENCE_NAME_SALES_ORDER_TYPE = 'SalesOrderType';  //販売オーダタイプ
    public static final String REFERENCE_NAME_SEMINAR_FIELD = 'SeminarField';       //講習：利用分野
    public static final String REFERENCE_NAME_SEMINAR_STATUS = 'SeminarStatus';     //講習：状態
    public static final String REFERENCE_NAME_SEMINAR_TYPE = 'SeminarType';         //講習種別
    public static final String REFERENCE_NAME_SERIES = 'Series';                    //系列
    public static final String REFERENCE_NAME_GLOBAL_SERIES = 'GlobalSeries';      //アジア・系列
    public static final String REFERENCE_NAME_SERVICE_AREA = 'ServiceArea';         //サービスエリア
    public static final String REFERENCE_NAME_QUOTE_TYPE = 'QuoteType';             //見積もり種別
    public static final String REFERENCE_NAME_PROFIT_CALCULATION_TYPE = 'ProfitCalculationType';
    public static final String REFERENCE_NAME_SERVICE_STATUS = 'ServiceStatus'; //サービス：ステータス
    public static final String REFERENCE_NAME_SERVICE_TYPE = 'ServiceType';         //サービス：サービス種別
    public static final String REFERENCE_NAME_QUOTATION_AREA_CODE = 'QuotationAreaCode';         //見積書地域コード
    public static final String REFERENCE_NAME_QUOTATION_DELIVERY_CONDITION = 'Q_DeliveryCondition';         //見積書受渡条件
    public static final String REFERENCE_NAME_QUOTATION_QUANTITY_UNIT = 'QD_QuantityUnit';         //見積書明細単位
    public static final String REFERENCE_NAME_INCOTERMS = 'Incoterms';         //サービス：サービス種別
    public static final String REFERENCE_NAME_INCOTERMS_DESTINATION = 'IncotermsDestination';         //サービス：サービス種別

    public static final String MSG_NUMBERING_ERROR = '採番した番号が規定の桁数を超えています。システム管理者にご連絡下さい。';

    public static String appendLikeText(String fieldName, String value) {
        return ' ' + escapeNull(fieldName) + ' LIKE \'%' + String.escapeSingleQuotes(escapeNull(value)) + '%\' ';
    }

    public static String appendBeforeLikeText(String fieldName, String value) {
        return ' ' + escapeNull(fieldName) + ' LIKE \'%' + String.escapeSingleQuotes(escapeNull(value)) + '\' ';
    }

    public static String appendAfterLikeText(String fieldName, String value) {
        return ' ' + escapeNull(fieldName) + ' LIKE \'' + String.escapeSingleQuotes(escapeNull(value)) + '%\' ';
    }

    public static String appendEqualText(String fieldName, String value) {
        return ' ' + escapeNull(fieldName) + ' = \'' + String.escapeSingleQuotes(escapeNull(value)) + '\' ';
    }

    public static String appendLessThanEqualText(String fieldName, String value) {
        return appendLessThanEqualText(fieldName, value, true);
    }
    public static String appendLessThanEqualText(String fieldName, String value, Boolean isSetQuote) {
        String coverText = '';
        if (isSetQuote) {
            coverText = '\'';
        }
        return ' ' + escapeNull(fieldName) + ' <= ' + coverText + String.escapeSingleQuotes(escapeNull(value)) + coverText + ' ';
    }

    public static String appendGreaterThanEqualText(String fieldName, String value) {
        return appendGreaterThanEqualText(fieldName, value, true);
    }
    
    public static String appendGreaterThanEqualText(String fieldName, String value, Boolean isSetQuote) {
        String coverText = '';
        if (isSetQuote) {
            coverText = '\'';
        }
        return ' ' + escapeNull(fieldName) + ' >= ' + coverText + String.escapeSingleQuotes(escapeNull(value)) + coverText + ' ';
    }

    public static String appendInText(String fieldName, List<String> values) {
        return appendInText(fieldName, values, false);
    }
    public static String appendInText(String fieldName, List<String> values, boolean isNot) {
        List<String> escapedValues = new List<String>();
        for (String value: values) {
            escapedValues.add(String.escapeSingleQuotes(escapeNull(value)));
        }
        String notContdision = '';
        if (isNot) {
            notContdision = ' NOT ';
        }
        return ' ' + escapeNull(fieldName) + notContdision + ' IN ' + ' (\'' + String.join(escapedValues, '\',\'') + '\') ';
    }
    
    public static String joinWhereConditions(List<String> conditions) {
        String ret;
        if (conditions == null) {
            conditions = new List<String>();
        }
        for (String condition: conditions) {
            if (ret != null) {
                ret += ' AND ' + condition;
            } else {
                ret = ' WHERE ' + condition;
            }
        }
        if (ret == null) {
            ret = '';
        }
        return ret;
    }
    
    public static String escapeNull(String value) {
        return String.isNotBlank(value) ? value : '';
    }

    // 顧客カテゴリの取得
    public static List<Category__c> getCategorys(){
        List<Category__c> categorys = [select Name, Code__c from Category__c order by Code__c];
        if(categorys == null){
            categorys = new List<Category__c>();
        }
        return categorys;
    }
    // 顧客カテゴリ.NameのSelectOption取得
    public static List<SelectOption> getCategoryNameOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        for (Category__c sList: getCategorys()){
            options.add(new SelectOption(sList.Code__c, sList.Name));
        }
        return options;
    }

    public static List<String> getCategoryJunctionAccountIds(String categoryCode){
        List<Account> accounts = [select Id from Account where Id in (select Account__c from CategoryJunction__c where CategoryName__r.Code__c =: categoryCode)];
        List<String> accountIds = new List<String>();
        for (Account accRec : accounts ){
            accountIds.add(accRec.Id);
        }
        return accountIds;
    }

    public static List<SelectOption> getSelectList
        (String referenceName) {
        return getSelectList(true, referenceName, false);
    }
    public static List<SelectOption> getSelectList(Boolean isSetBlank, String referenceName) {
        return getSelectList(isSetBlank, referenceName, false);
    }
    public static List<SelectOption> getSelectList(Boolean isSetBlank, String referenceName, Boolean isLabelToValue) {
        List<SelectListManage__c> slManages = getSelectListRecs(referenceName);
        List<SelectOption> selectOptions = getSelectListFromSLManage(isSetBlank, slManages, isLabelToValue);
        return selectOptions;
    }

    public static List<SelectOption> getSelectListFromSLManage(Boolean isSetBlank, List<SelectListManage__c> SelectListManageRecs, Boolean isLabelToValue) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        if (isSetBlank) {
            selectOptions.add(new SelectOption('', ''));
        }
        for (SelectListManage__c rec: SelectListManageRecs) {
            if (!rec.Hidden__c) {
                String label = nullTransform(rec.label__c);
                String value = null;
                if (isLabelToValue) {
                    value = label;
                } else {
                    value = nullTransform(rec.value__c);
                }
                SelectOption option = new SelectOption(value, label, rec.Disabled__c);
                option.setDisabled(rec.Disabled__c);
                selectOptions.add(option);
            }
        }
        return selectOptions;
    }
    public static List<SelectListManage__c> getSelectListRecs(String referenceName) {
        List<SelectListManage__c> recs = [
            SELECT
                Name,
                ReferenceName__c,
                Value__c,
                Label__c,
                Description__c,
                Disabled__c,
                Hidden__c,
                SortNo__c
            FROM
                SelectListManage__c
            WHERE
                ReferenceName__c =: referenceName
            ORDER BY 
                SortNo__c
        ];
        return recs;
    }
    
    public static String nullTransform(String value) {
        String ret = '';
        if (String.isNotBlank(value)) {
            ret = value;
        }
        return ret;
    }

    public static Decimal getTaxationValue() {
        Decimal value = getTaxationRate();
        return value.divide(100,2);
    }

    public static Decimal getTaxationRate() {
        TaxSetting__c taxInfo = TaxSetting__c.getOrgDefaults();
        Decimal configuerValue = null;
        if (taxInfo != null) {
            configuerValue = taxInfo.TaxationRate__c;
        }
        if (configuerValue == null) {
            configuerValue = 0;
        }
        return configuerValue;
    }
    
    private static Map<String, JapaneseEraNameMaster__c> eras = JapaneseEraNameMaster__c.getAll();
    public static List<JapaneseEraNameMaster__c> getDateDescList() {
        JapaneseEraNameMaster__c[] eraArray = eras.values();
        eraMargeSort(eraArray, 0, eraArray.size() - 1);
        return eraArray;
    }
    public static void eraMargeSort(JapaneseEraNameMaster__c[] targets, Integer left, Integer right) {
        if (left < right) {
            Integer i, j, k;
            JapaneseEraNameMaster__c[] temp = new JapaneseEraNameMaster__c[targets.size()];
            Integer center = (left + right) / 2;
            eraMargeSort(targets, left, center);
            eraMargeSort(targets, center + 1, right);
            for (i = left; i <= center; i++) {
                temp[i] = targets[i];
            }
            
            j = right;
            for (i = center + 1; i <= right; i++) {
                temp[i] = targets[j];
                j--;
            }

            i = left;
            j = right;
            for (k = left; k <= right; k++) {
                if (temp[i].JapaneseCalendarStartDate__c >= temp[j].JapaneseCalendarStartDate__c) {
                    targets[k] = temp[i++];
                } else {
                    targets[k] = temp[j--];
                }
            }
        }
    }
    public static Map<String, String> getJapaneseEraData(Date value) {
        return getJapaneseEraData(value,  true);
    }
    public static Map<String, String> getJapaneseEraData(Date value, Boolean isFirstYearFormat) {
        Map<String, String> eraData = new Map<String, String>();
        if (value != null) {
            List<JapaneseEraNameMaster__c> dateDescList = getDateDescList();
            JapaneseEraNameMaster__c targetEraData = null;
            for (JapaneseEraNameMaster__c rec: dateDescList) {
                if (value >= rec.JapaneseCalendarStartDate__c) {
                    targetEraData = rec;
                    break;
                }
            }
            if (targetEraData != null) {
                eraData.put('name', targetEraData.Name);
                Integer eraYear = value.year() - targetEraData.JapaneseCalendarStartDate__c.year();
                String retYear = null;
                if (eraYear == 0 && isFirstYearFormat) {
                    retYear = '元';
                } else {
                    retYear = String.valueOf(eraYear + 1);
                }
                eraData.put('year', retYear);
            }
        }
        return eraData;
    }
    
    public static DescribeSobjectResult setSameRoleSharing(String objectName, Map<String, String> idAndSeriesMap) {
        DescribeSObjectResult targetDescribe;
        Schema.SObjectType targetSObjectType;
        Map<String, Schema.SobjectType> globalDescribe = Schema.getGlobalDescribe();
        if (globalDescribe.containsKey(objectName)) {
            Schema.SobjectType sType = globalDescribe.get(objectName);
            DescribeSobjectResult dsResult = sType.getDescribe();
            for (Schema.Childrelationship csType: dsResult.getChildRelationships()) {
                if (csType.getRelationShipName() == 'Shares') {
                    targetSObjectType = csType.getChildSObject();
                    targetDescribe = targetSObjectType.getDescribe();
                    break;
                }
            }
        }
        
        if (targetDescribe != null) {
            Set<String> seriesCodes = new Set<String>();
            Map<String, String> idAndUserRoleNameMap = new Map<String, String>();
            for (String key: idAndSeriesMap.keySet()) {
                String roleName = idAndSeriesMap.get(key);
                if (String.isNotBlank(roleName)) {
                    String nameFirstText = roleName.substring(0, 1);
                    if (nameFirstText.isNumeric()) {
                        roleName = 'X' + roleName;
                    }
                    idAndUserRoleNameMap.put(key, roleName);
                    seriesCodes.add(roleName);
                }
            }

            List<UserRole> seriesRole = [SELECT id, DeveloperName FROM UserRole WHERE DeveloperName IN: seriesCodes];
            if (seriesRole != null) {
                String soql = ' SELECT id FROM ' + targetDescribe.getName() + ' WHERE parentId IN (\'' + String.join(new List<String>(idAndSeriesMap.keySet()), '\',\'') + '\') AND RowCause = \'KeiretsuRoleSharing__c\'';
                List<Sobject> oldShares = Database.query(soql);
                if (oldShares != null && oldShares.size() > 0) {
                    delete oldShares;
                }
                Map<String, UserRole> userRoleIdMap = new Map<String, UserRole>(seriesRole);
                String scvTopRoleGroupName = 'SVCTopRoles';
                List<Group> seriesGroup = [SELECT id, RelatedId, DeveloperName FROM Group WHERE RelatedId IN: userRoleIdMap.keySet() OR DeveloperName =: scvTopRoleGroupName];
                Map<String, String> seriesAndGroupIdMap = new Map<String, String>();
                
                Group scvTopRoleGroup;
                for (Group grp: seriesGroup) {
                    if (grp.DeveloperName == scvTopRoleGroupName) {
                        scvTopRoleGroup = grp;
                        continue;
                    }
                    seriesAndGroupIdMap.put(userRoleIdMap.get(grp.RelatedId).DeveloperName, grp.id);
                }
                if (seriesAndGroupIdMap.size() > 0) {
                    List<SObject> newShares = new List<SObject>();
                    for (String targetId: idAndUserRoleNameMap.keySet()) {
                        String seriesCode = idAndUserRoleNameMap.get(targetId);
                        String groupId = seriesAndGroupIdMap.get(seriesCode);
                        if (groupId != null) {
                            SObject share = targetSObjectType.newSObject();
                            share.put('RowCause', 'KeiretsuRoleSharing__c');
                            share.put('AccessLevel', 'Read');
                            share.put('ParentId', targetId);
                            share.put('UserOrGroupId', groupId);
                            newShares.add(share);
                        }
                        if (scvTopRoleGroup != null) {
                            SObject share = targetSObjectType.newSObject();
                            share.put('RowCause', 'BumonRoleSharing__c');
                            share.put('AccessLevel', 'Read');
                            share.put('ParentId', targetId);
                            share.put('UserOrGroupId', scvTopRoleGroup.id);
                            newShares.add(share);
                        }
                    }
                    if (newShares.size() > 0) {
                        insert newShares;
                    }
                }
            }
        }
        return targetDescribe;
    }
    
    public static final String NUMBERING_MASTER_KEY_QUOTE_NO = 'QuoteNoMaster'; 
    public static final String NUMBERING_MASTER_KEY_ASIAPROFITCALC_NO = 'AsiaProfitCalcNoMaster'; 
    public static final String NUMBERING_MASTER_KEY_ASIAQUOTATION_NO = 'AsiaQuotationNoMaster'; 

    public static NumberingMaster__c getTargetMaster(String typeStr, String prefix, String suffix) {
        NumberingMaster__c ret = null;
        //Add "For Update" 2015/08/18 by mkubomura
        List<NumberingMaster__c> recs = [
                SELECT
                    ID, Name, Prefix__c, Suffix__c, Type__c, Digit__c, CurrentNumber__c
                FROM
                    NumberingMaster__c
                WHERE
                    Type__c =: typeStr AND Prefix__c =: prefix AND Suffix__c =: suffix
                For Update
        ];
        if (recs != null && recs.size() == 1) {
            ret = recs.get(0);
        } else {
            JEOLException e = new JEOLException('SB001');
            throw e;
        }
        return ret;
    }
    public static String nextNumberingValue(NumberingMaster__c rec) {
        String ret = null;
        if (rec == null) {
            throw new JEOLException('SB002');
        }
        Integer value = Integer.valueOf(rec.CurrentNumber__c);
        Integer digit = Integer.valueOf(rec.Digit__c);
        ret = paddingLeftPadding(value, digit);
        
        if (digit < ret.length()) {
            throw new JEOLException('SB003');
        }

        if (String.isNotBlank(rec.Prefix__c)) {
            ret = rec.Prefix__c + ret;
        }
        if (String.isNotBlank(rec.Suffix__c)) {
            ret = ret + rec.Suffix__c;
        }
        return ret;
    }
    public static void numberingUpdate(NumberingMaster__c rec) {
        if (rec != null && rec.CurrentNumber__c != null && rec.Digit__c != null) {
            rec.CurrentNumber__c++;
            /*
            if (rec.Digit__c < String.valueOf(rec.CurrentNumber__c).length()) {
                // comment out because of changing the spec 20150821
                // rec.CurrentNumber__c = 1;   //Roate to 1 2015/08/18 by mkubomura 
               
                // throw new JEOLException('SB003'); // No need to throw it now, it will be thrown when getting the next number
            }
            */
            update rec;
        }
    }
    public static String paddingLeftPadding(Integer targetNum, Integer length) {
        String ret = String.valueOf(targetNum);
        Integer retLen = ret.length();
        if(length > retLen) {
            for(Integer i = retLen; i < length; i++) {
                ret = '0' + ret;
            }
        }
        return ret; 
    }
    
    public static final String NUMBERING_MASTER_KEY_PIPELINE_NO = 'PipelineNoMaster'; 

    public static String nextNumberingPipelineValue() {

        NumberingMaster__c rec = null;

        List<NumberingMaster__c> recs = [
                SELECT ID, Name, Prefix__c, Suffix__c, Type__c, Digit__c, CurrentNumber__c
                FROM   NumberingMaster__c
                WHERE  Type__c =:NUMBERING_MASTER_KEY_PIPELINE_NO
                FOR UPDATE
        ];

        if (recs != null && recs.size() == 1) {
            rec = recs.get(0);
        } else {
            rec = new NumberingMaster__c();
            rec.Type__c = NUMBERING_MASTER_KEY_PIPELINE_NO;
            rec.Digit__c = 8;
            rec.CurrentNumber__c = 1;
            insert rec;
        }
        
        Integer value = Integer.valueOf(rec.CurrentNumber__c);
        Integer digit = Integer.valueOf(rec.Digit__c);
        String ret = paddingLeftPadding(value, digit);
        
        if (digit < ret.length()) {
            throw new JEOLException('SB003');
        }

        if (String.isNotBlank(rec.Prefix__c)) {
            ret = rec.Prefix__c + ret;
        }
        if (String.isNotBlank(rec.Suffix__c)) {
            ret = ret + rec.Suffix__c;
        }
        
        rec.CurrentNumber__c++;
        update rec;
        
        return ret;
    }
    
    
    public static List<String> createTextLines(String text, Integer textSize) {
        return createTextLines(text, textSize, -1);
    }
    public static List<String> createTextLines(String text, Integer textSize, Integer lineLimit) {
        List<String> ret = null;
        Boolean isLimit = (lineLimit > 0);
        if (String.isNotBlank(text)) {
            List<String> lines = text.split('\n',-1);
            List<String> newLines = new List<String>();
            for (String line: lines) {
                Decimal totalByte = 0;
                String newLine = '';
                for (Integer i = 0; i < line.length(); i++) {
                    String charText = line.substring(i, i + 1);
                    Decimal value = (JEOLUtil.getBytes(charText) < 2 ?  1.02 : 2);
                    if (totalByte + value > textSize*2) {
                        totalByte = 0;
                        newLines.add(newLine);
                        newLine = '';
                        if (isLimit && lineLimit <= newLines.size()) {
                            break;
                        }
                    }
                    newLine += charText;
                    totalByte += value;
                }
                newLines.add(newLine);
                if (isLimit && lineLimit <= newLines.size()) {
                    break;
                }
            }
            ret = newLines;
        }
        if (ret == null) {
            ret = new List<String>();
        }
        return ret;
    }
    public static Integer getBytes(String strings) {
        return Blob.valueOf(strings).size();
    }
    
    /**
     * Byte 数以下か判定を行う
     * @param bytes byte 数
     * @param s 文字列
     * @return true: 以下／false: より上
     */
    public static Boolean isByteLessThan(Integer bytes, String s) {
        return bytes >= getSizeInBytes(s);
    }
    
    public static Integer getSizeInBytes(String s) {

        if(s == null || s == '') return 0;
    
        Integer zenkakuLength = s.replaceAll('[\\uFF61-\\uFF9F\\u0020-\\u007E]', '').length();
        Integer hankakuLength = s.length() - zenkakuLength;
        return zenkakuLength * 2 + hankakuLength;

    }
        
}