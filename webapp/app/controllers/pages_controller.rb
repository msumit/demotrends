class PagesController < ApplicationController
  # GET /pages
  protect_from_forgery :only => [:create, :update, :destroy]
  layout 'pages'#, :except => [:auto_complete_for_search_query]
 
  caches_page :show
  caches_page :csv  
  
    
  def index
    @dates=MonthlyTrend.select(:date).order("date desc").map(&:date).uniq
    @on_date = params[:date] ? Date.strptime(params[:date],"%m/%d/%Y") : @dates[0]

    @min =  @dates.min
    @max =  @dates.max
    
    # monthly trends 
    @monthlytrend= MonthlyTrend.find(:all, :limit => APP_CONFIG['articles_per_page'] , :order => 'trend DESC', :conditions => ["date = ? and page_id NOT IN (?)", @on_date, APP_CONFIG['blacklist']])
    @pages =[]
    @monthlytrend.each do |mt|
      @pages << mt.page
    end  
    Rails.logger.debug("#{@pages.inspect}")  
    unless params[:page]
      params[:page]='1'
    end  
      
    respond_to do |format|
      format.html # index.html.erb
    end      
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  

end
