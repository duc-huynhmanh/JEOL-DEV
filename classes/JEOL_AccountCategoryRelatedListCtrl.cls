public with sharing class JEOL_AccountCategoryRelatedListCtrl {

	private CustomRelatedListCtrl relatedListCtrl = null;
	public String parentId{get; set;}
	public String title{get; set;}
	public Boolean isEdit{get; set;}
	public Boolean isSuccess{get; set;}

	public String[] SobjectFields = new String[]{'name','Code__c'};

	public JEOL_AccountCategoryRelatedListCtrl() {
		this.isSuccess = true;
	}

	public CustomRelatedListCtrl getRelatedListCtrl() {
		if (this.relatedListCtrl == null) {
			try {
				this.relatedListCtrl = new CustomRelatedListCtrl(this.SobjectFields, this.parentId);
				this.relatedListCtrl.title = this.title;
			} catch (System.QueryException e) {
				this.isSuccess = false;
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));//'情報取得エラー'));
			}
		}
		
		return this.relatedListCtrl;
	}

	public class CustomRelatedListCtrl {
		public ApexPages.StandardSetController ssc{get; set;}
		public List<String> fieldNames{get; set;}
		public String sobjectName{get; set;}
		public String viewId{get; set;}
		public String title{get; set;}
		public String targetId{get; set;}
		public String relationshipName{get; set;}
		public String test{get; set;}
		public CustomRelatedListCtrl(List<String> fieldNames, String targetId) {
			if (fieldNames != null && fieldNames.size() > 0) {
				this.fieldNames = fieldNames;
				this.targetId = targetId;
				List<CategoryJunction__c> junctions = [SELECT id, CategoryName__c FROM CategoryJunction__c WHERE Account__c =: targetId];
				if (junctions != null) {
					this.test = String.valueOf(junctions.size());
				}
				Set<String> ids = new Set<String>();
				for (CategoryJunction__c junction: junctions) {
					if (String.isNotBlank(junction.CategoryName__c)) {
						ids.add(junction.CategoryName__c);
					}
				}
				
				String queryStr = ' SELECT ' + String.join(fieldNames,',') + ' FROM Category__c ';
				queryStr += ' WHERE id IN (\'' +  String.join((new List<String>(ids)), '\',\'') + '\')';
				Database.QueryLocator locator = Database.getQueryLocator(queryStr);
				if (locator != null) {
					this.ssc = new ApexPages.StandardSetController(locator);
					this.ssc.setPageSize(5);
					this.ssc.setPageNumber(1);
				}
			}
		}
		
		public List<Sobject> getRecords() {
			List<Sobject> recs;
			if (this.ssc != null) {
				recs = this.ssc.getRecords();
			} else {
				recs = new List<Sobject>();
			}
			return recs;
		}
		
		public Integer getResultSize() {
			Integer resultSize = 0;
			if (this.ssc != null) {
				resultSize = this.ssc.getResultSize();
			}
			return resultSize;
		}
		
		public void AddViewSize() {
			Integer viewSize = 0;
			if (this.ssc != null) {
				Integer currentViewSize = this.ssc.getPageSize();
				viewSize = currentViewSize*2;
				if (80 < viewSize) {
					viewSize = 125;
				}
			}
			this.ssc.setPageSize(viewSize);
		}
		public Integer getCurrentViewSize() {
			Integer viewSize = 0;
			if (this.ssc != null) {
				viewSize = this.ssc.getPageSize();
			}
			return viewSize;
		}
		
		/*public Pagereference getAllRecordViewUrl() {
			Pagereference ref = Page.JEOL_CustomRelatedListAllRecordViewPage;
			Map<String, String> params = new Map<String, String>();
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SOBJECT, this.sobjectName);
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_FIELD, String.join(this.fieldNames,','));
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_ID, this.targetId);
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_RELATIONSHIP, this.relationshipName);
			ref.getParameters().putAll(params);
			return ref;
		}*/
	}
}