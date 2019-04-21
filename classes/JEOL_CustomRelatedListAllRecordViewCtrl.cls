public with sharing class JEOL_CustomRelatedListAllRecordViewCtrl {

	public List<Sobject> records{get; set;}
	public String sobjectName{get; set;}
	public List<String> fieldNames{get; set;}
	public String targetId{get; set;}
	public String relationshipName{get; set;}
	public Integer startCount{get; set;}
	private transient DescribeSobjectResult describeResult;
	public Account targetAccount{get; set;}
	public String sortTarget{get; set;}
	public Integer sortType;
	public Boolean hasMoreRecords{get; set;}
	

	public static final String URL_PARAM_SOBJECT = 'sobject';
	public static final String URL_PARAM_FIELD = 'fields';
	public static final String URL_PARAM_ID = 'id';
	public static final String URL_PARAM_RELATIONSHIP = 'relationship';
	public static final String URL_PARAM_START = 'start';
	public static final String URL_PARAM_SORT_TYPE = 'sorttype';
	public Integer viewSize = 50;

	public JEOL_CustomRelatedListAllRecordViewCtrl() {
		Map<String, String> params = Apexpages.currentPage().getParameters();
		if (params.containsKey(URL_PARAM_SOBJECT) &&
				params.containsKey(URL_PARAM_FIELD) &&
				params.containsKey(URL_PARAM_ID) &&
				params.containsKey(URL_PARAM_RELATIONSHIP)) {

			this.sobjectName = String.escapeSingleQuotes(params.get(URL_PARAM_SOBJECT));
			this.fieldNames = params.get(URL_PARAM_FIELD).split(',', 0);
			this.targetId = String.escapeSingleQuotes(params.get(URL_PARAM_ID));
			this.relationshipName = String.escapeSingleQuotes(params.get(URL_PARAM_RELATIONSHIP));
			this.startCount = 0;
			if(params.containsKey(URL_PARAM_START) && params.get(URL_PARAM_START).isNumeric()) {
				this.startCount = Integer.valueOf(params.get(URL_PARAM_START));
			}
			if(params.containsKey(URL_PARAM_SORT_TYPE)) {
				String sortTypeValue = params.get(URL_PARAM_SORT_TYPE);
				Pattern isnumbers = Pattern.Compile('^[-]?[0-9]+$');
				Matcher numberMatch = isnumbers.matcher(sortTypeValue);
				if (numberMatch.Matches()) {
					this.sortType = Integer.valueOf(params.get(URL_PARAM_SORT_TYPE));
				}
			}
			this.describeResult = getSobjectDescribe(this.sobjectName);
			
			List<Account> parentRecs = [SELECT id, name FROM Account WHERE id =: this.targetId];
			if (parentRecs != null && parentRecs.size() > 0) {
				this.targetAccount = parentRecs.get(0);
			} else {
				this.targetAccount = new Account();
			}
			String queryStr = getQueryStr(this.sobjectName, this.fieldNames, this.targetId, this.relationshipName, this.startCount);
			this.records = Database.query(queryStr);
			hasMoreRecords = (this.records != null && this.records.size() > viewSize);
			if (hasMoreRecords) {
				this.records.remove(viewSize);
			}
		}
	}

	public String getListSobjectName() {
		String name = '';
		if (this.describeResult != null) {
			name = this.describeResult.getLabel();
		}
		return name;
	}

	private String getQueryStr(String sobjectName, List<String> fieldNames, String targetId, String relationshipName, Integer startCount) {
		String queryStr = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sobjectName;
		String condition = ' WHERE ' +
								relationshipName + '.id = \'' + targetId + '\' ' +
							'OR ' +
								relationshipName + '.ParentId = \'' + targetId + '\' ';
		if (this.sortType != null) {
			Integer sortTargetNumber = Math.abs(this.sortType);
			if (sortTargetNumber != 0 && fieldNames.size() >= sortTargetNumber) {
				condition += ' ORDER BY ' + this.fieldNames.get(sortTargetNumber - 1) + ' ';
				System.debug(this.sortType);
				if (this.sortType < 0) {
					System.debug('desc');
					condition += ' DESC NULLS LAST ';
				}
			}
		}
		condition += ' LIMIT ' + String.valueOf(this.viewSize + 1) +
					' OFFSET ' + String.valueOf(startCount);
		return queryStr + condition;
	}

	private DescribeSobjectResult getSobjectDescribe(String sobjectName) {
		DescribeSobjectResult ret;
		Map<String, Schema.Sobjecttype> globalDescribe = Schema.getGlobalDescribe();
		if (globalDescribe.containsKey(sobjectName)) {
			ret = globalDescribe.get(sobjectName).getDescribe();
		}
		return ret;
	}
	
	public Pagereference pageNext() {
		Pagereference ret = getBaseUrl();
		Integer nextCount = this.startCount + this.viewSize;
		ret.getParameters().put(URL_PARAM_START, String.valueOf(nextCount));
		return ret;
	}
	public Pagereference pagePrev() {
		Pagereference ret = getBaseUrl();
		Integer prevCount = this.startCount - this.viewSize;
		if (prevCount < 0) {
			prevCount = 0;
		}
		ret.getParameters().put(URL_PARAM_START, String.valueOf(prevCount));
		return ret;
	}
	
	public Pagereference sortAction() {
		Pagereference ret = getBaseUrl();
		
		Integer fieldNum = 0;
		for (Integer i = 0; i< fieldNames.size(); i++) {
			String fieldName = fieldNames.get(i);
			if (this.sortTarget == fieldName) {
				fieldNum = i + 1;
				break;
			}
		}
		if (fieldNum == this.sortType) {
			fieldNum *= -1;
		}
		if (fieldNum != 0) {
			ret.getParameters().put(URL_PARAM_SORT_TYPE, String.valueOf(fieldNum));
		}
		return ret;
	}
	
	private Pagereference getBaseUrl() {
		Pagereference ref = Page.JEOL_CustomRelatedListAllRecordViewPage;
		Map<String, String> params = new Map<String, String>();
		params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SOBJECT, this.sobjectName);
		params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_FIELD, String.join(this.fieldNames,','));
		params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_ID, this.targetId);
		params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_RELATIONSHIP, this.relationshipName);
		if (this.sortType != null) {
			params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SORT_TYPE, String.valueOf(this.sortType));
		}
		ref.getParameters().putAll(params);
		ref.setRedirect(true);
		return ref;
	}
}