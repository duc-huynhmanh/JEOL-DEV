public with sharing abstract class JEOL_SearchBase_ctrl {

	protected Integer pageSize = 50;
    protected Integer pageNo = 1;
    protected String currentOrder = 'name';

    public String orderBy { get; set; }
    public Boolean orderDesc { get; set; }
    public ApexPages.StandardSetController ssc { get; set; }

    /**
     * コンストラクタ
     */
    public JEOL_SearchBase_ctrl() {
    }

    /**
     * StandardSetControllerをセット
     */
    protected virtual void setStandardSetController(){}


    /**
     *  ページサイズ取得
     */
    public Integer getPageSize() {
        return this.pageSize;
    }
    /**
     *  ページサイズセット
     */
    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    /**
     * ページサイズ変更
     */
    public PageReference changeSize() {
        if (this.ssc != null) {
            this.ssc.setPageNumber(1);  // ページNoを初期化
            this.ssc.setPageSize(this.pageSize);
        }
        return null;
    }

    /**
     * 指定のページへ
     */
    public PageReference jump() {
        if (this.ssc != null) {
            this.pageNo = this.ssc.getPageNumber();
        }
        return null;
    }

    /**
     * 最初のページへ
     */
    public PageReference first() {
        if (this.ssc != null) {
            ssc.first();
            this.pageNo = this.ssc.getPageNumber();
        }
        return null;
    }

    /**
     * 最後のページへ
     */
    public PageReference last() {
        if (this.ssc != null) {
            ssc.last();
            this.pageNo = this.ssc.getPageNumber();
        }
        return null;
    }
    /**
     * 次へ
     */
    public PageReference next() {
        if (this.ssc != null) {
            ssc.next();
            this.pageNo = this.ssc.getPageNumber();
        }
        return null;
    }
    /**
     * 前へ
     */
    public PageReference previous() {
        if (this.ssc != null) {
            ssc.previous();
            this.pageNo = this.ssc.getPageNumber();
        }
        return null;
    }

    /**
     * ソート
     */
    public PageReference changeOrder() {
        if (this.orderBy == this.currentOrder) {
            this.orderDesc = !this.orderDesc;
        } else {
            this.currentOrder = this.orderBy;
        }
        if (this.ssc != null) {
            this.ssc.setPageNumber(1);  // ページNoを初期化
            this.pageNo = this.ssc.getPageNumber();
            setStandardSetController();
        }
        return null;
    }
}