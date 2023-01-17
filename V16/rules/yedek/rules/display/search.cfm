<cfinclude template="../query/get_content_cat.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="search_rule" action="#request.self#?fuseaction=rule.welcome" method="post">
	<input type="hidden" name="is_from_rule" id="attributes.is_from_rule" value="1">

<div class="row w3-filtre">
  <div class="col-xl-6 offset-xl-3 col-lg-8 offset-lg-2 col-md-10 offset-md-1">
      <div class="row">
      
          <div class="col-md-4 searchCombo  p-md-0">
              <select class="custom-select form-control w-100" name="cat_chapter" id="cat_chapter" >
                  <option selected value="0"><cfoutput>#getLang("invoice",278,"Seçim Yapınız")#</cfoutput></option>
                 <!--    >
                        menüleri döndür
                     -->
                  <option value="1">Literatür</option>
                  <option value="2">Forum</option>
                  <option value="4">Eğitim</option>
                  <option value="5">Dijital Arşiv</option>
                  <option value="6">Kim Kimdir?</option>
              </select>
          </div>
          <div class="col-md-7 searchInput  p-md-0">
              <input class="form-control w-100" name="keyword" id="keyword" type="search" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#getLang("forum",17,"Ne Aramıştınız?")#</cfoutput>">
          </div>
          <div class="col-md-1 searchButton p-md-0">
              <button type="submit"  class="btn btn-primary btn-block" >
                  <span class="wrk-search"></span>
              </button>
          </div>
          
          
      </div>
  </div>
</div>

</cfform>
