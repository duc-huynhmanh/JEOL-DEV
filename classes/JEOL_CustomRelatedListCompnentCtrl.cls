public with sharing class JEOL_CustomRelatedListCompnentCtrl {
	
	private CustomRelatedListCtrl relatedListCtrl = null;
	public String SobjectName{get; set;}
	public String[] SobjectFields{get; set;}
	public String parentId{get; set;}
	public String parentRelationshipName{get; set;}
	public String title{get; set;}
	public Boolean isEdit{get; set;}
	public Boolean isSuccess{get; set;}
	
	public JEOL_CustomRelatedListCompnentCtrl() {
		this.isSuccess = true;
	}
	
	public CustomRelatedListCtrl getRelatedListCtrl() {
		if (this.relatedListCtrl == null) {
			try {
				this.relatedListCtrl = new CustomRelatedListCtrl(this.SobjectName, this.SobjectFields, this.parentId, this.parentRelationshipName);
				this.relatedListCtrl.title = this.title;
			} catch (System.QueryException e) {
				this.isSuccess = false;
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '情報取得エラー'));
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
		public CustomRelatedListCtrl(String sobjectName, List<String> fieldNames, String targetId, String relationshipName) {
			if (fieldNames != null && fieldNames.size() > 0 && String.isNotBlank(sobjectName)) {
				this.sobjectName = sobjectName;
				this.fieldNames = fieldNames;
				this.targetId = targetId;
				this.relationshipName = relationshipName;
				String queryStr = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sobjectName;
				queryStr += ' ' + getQueryCondition(relationshipName, targetId);
				System.debug(queryStr);
				Database.QueryLocator locator = Database.getQueryLocator(queryStr);
				if (locator != null) {
					this.ssc = new ApexPages.StandardSetController(locator);
					this.ssc.setPageSize(5);
					this.ssc.setPageNumber(1);
				}
			}
		}
		
		public String getQueryCondition(String relationshipName, String targetId) {
			String escapeTargetId = String.escapeSingleQuotes(targetId);
			String escapeRelationshipName = String.escapeSingleQuotes(relationshipName);
			String condition = ' WHERE ';
			condition += ' ' + escapeRelationshipName + '.id = \'' + targetId + '\' ';
			condition += ' OR ';
			condition += ' ' + escapeRelationshipName + '.ParentId = \'' + targetId + '\' ';
			condition += ' ORDER BY Name  ';
			condition += ' LIMIT 150';
			return condition;
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
		
		public Pagereference getAllRecordViewUrl() {
			Pagereference ref = Page.JEOL_CustomRelatedListAllRecordViewPage;
			Map<String, String> params = new Map<String, String>();
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SOBJECT, this.sobjectName);
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_FIELD, String.join(this.fieldNames,','));
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_ID, this.targetId);
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_RELATIONSHIP, this.relationshipName);
			ref.getParameters().putAll(params);
			return ref;
		}
	}
}