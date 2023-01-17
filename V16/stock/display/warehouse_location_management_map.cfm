<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.3pl" default="1">
<cfparam name="attributes.get_department_values" default="">
<cfquery name="get_pos_id" datasource="#dsn#">
	SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="get_locations" datasource="#dsn#">
	SELECT 
		*
	FROM 
		STOCKS_LOCATION
	<cfif len(attributes.get_department_values)>
	WHERE DEPARTMENT_ID=#attributes.get_department_values#
	</cfif>
</cfquery>
<cfquery name="periods" datasource="#dsn#">
	SELECT DISTINCT
		O.COMP_ID,
		O.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP, 
		EMPLOYEE_POSITION_PERIODS EP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		EP.PERIOD_ID = SP.PERIOD_ID AND 
		EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
	ORDER BY
		O.COMP_ID,
		O.COMPANY_NAME
</cfquery>
<cfif isdefined("attributes.is_submitted")>
<cfquery name="get_stock_locations" datasource="#dsn#">
	SELECT
	<cfif attributes.3pl eq 1>
		ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.FROM_PP_ID = PP.PRODUCT_PLACE_ID),0) AS CIKIS,
		ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.TO_PP_ID = PP.PRODUCT_PLACE_ID),0) AS GIRIS,
	<cfelse>
		ISNULL((SELECT SUM(STOCK_OUT) FROM #DSN2#.STOCKS_ROW SR WHERE SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID),0) AS CIKIS,
		ISNULL((SELECT SUM(STOCK_IN) FROM #DSN2#.STOCKS_ROW SR WHERE SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID),0) AS GIRIS,	
	</cfif>
		SL.COMMENT,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		PP.SHELF_CODE,
		PP.PRODUCT_PLACE_ID,
		D.DEPARTMENT_HEAD,
		SL.ID
	FROM 
		STOCKS_LOCATION SL,
		#dsn3_alias#.PRODUCT_PLACE PP,
		DEPARTMENT D,
		BRANCH B
	WHERE
		SL.LOCATION_ID = PP.LOCATION_ID AND
		SL.DEPARTMENT_ID = PP.STORE_ID AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID
		<cfif attributes.get_department_values neq -1 and attributes.get_department_values neq ''>
			AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_department_values#">
		</cfif>
		<cfif len(attributes.company_id)>
			AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif len(attributes.keyword)>
			AND PP.SHELF_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif len(attributes.branch_id) and len(attributes.branch)>
			AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.location_id)>
			AND SL.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
		</cfif>
	ORDER BY
		SL.COMMENT,
		PP.PRODUCT_PLACE_ID
</cfquery>
<cfquery name="get_dolular" dbtype="query">
	SELECT * FROM get_stock_locations WHERE GIRIS > CIKIS
</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
	<cfform name="list_department" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.location_map">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<cf_box_search more="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
					<input type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57453.Şube'></cfoutput>" name="branch" id="branch" value="<cfif isdefined('attributes.branch') and len(attributes.branch)><cfoutput>#attributes.branch#</cfoutput></cfif>" style="width:80px;">
					<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=list_department.branch&field_branch_id=list_department.branch_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list');"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="company_id" id="company_id" onchange="degisim()" style="width:120px;">
					<option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
					<cfoutput query="periods">
						<option value="#COMP_ID#" <cfif COMP_ID eq attributes.company_id>selected</cfif>>#COMPANY_NAME#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group medium" >
				<select id="get_department_values" name="get_department_values">    
					<cfquery name="get_depo" datasource="#dsn#">
					   SELECT  DEPARTMENT_HEAD,DEPARTMENT_ID FROM  DEPARTMENT
					</cfquery> 
					<option value="-1"><cf_get_lang dictionary_id='58763.Depo'></option>
					<cfoutput query="get_depo">
						<option value="#DEPARTMENT_ID#" <cfif attributes.get_department_values eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="location_id" id="location_id" style="width:120px;">
					<option value=""><cf_get_lang dictionary_id='30031.Lokasyon'></option>
					<cfoutput query="get_locations">
						<option value="#ID#" <cfif ID eq attributes.location_id>selected</cfif>>#COMMENT#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="3pl" id="3pl" style="width:120px;">
					<option value="1" <cfif attributes.3pl eq 1>selected</cfif>><cf_get_lang dictionary_id='63804.3PL'></option>
					<option value="2" <cfif attributes.3pl eq 2>selected</cfif>><cf_get_lang dictionary_id='30867.Ofis İçi'></option>
				</select>
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
	</cfform>
</cf_box>
</div>
<cfif (isDefined("attributes.is_submitted")) and (len(attributes.keyword) or len(attributes.branch_id) or len(attributes.company_id) or not attributes.get_department_values eq -1 or len(attributes.location_id))>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		
			<cf_box><cf_box_search><cfoutput><div class="form-group col col-12" style="margin-top:7px;margin-bottom:7px;">
				<div class="col col-6"><div class="portHeadLightTitle">
					<cfif len(attributes.get_department_values) or len(attributes.location_id)>
					<span><a href="javascript://">#get_stock_locations.DEPARTMENT_HEAD#</a></span> 
					</cfif>
					<cfif len(attributes.location_id) and len(get_stock_locations.comment)>
                     <span><a href="javascript://">&nbsp;/ #get_stock_locations.comment#</a></span> 
					</cfif>
                </div>
			</div>
			<cfset bos=TLFormat(get_stock_locations.recordcount - get_dolular.recordcount,0)>
			<cfset dolu=TLFormat(get_dolular.recordcount,0)>
			<cfset toplam=TLFormat(get_stock_locations.recordcount,0)>
			<div class="col col-8 ui-form-list flex-end form-group">
				<div class="col col-6">
					<div class="col col-11  ui-form-list flex-end">
				<cf_get_lang dictionary_id="57492.Toplam">#getlang('','Raf','45667')#:&nbsp;
					<span data-counter="counterup" class="bold">#toplam#&nbsp;</span>
					-
					<cf_get_lang dictionary_id="55541.Dolu">#getlang('','Raf','45667')#:&nbsp;
			
					
					<span data-counter="counterup" class="bold">#dolu#&nbsp;</span>
					-
					<cf_get_lang dictionary_id="30941.Boş">#getlang('','Raf','45667')#:&nbsp;
				
					<span data-counter="counterup" class="bold">#bos#&nbsp;</span>
				</div><div class="col col-1"></div>
				</div>
			<div class="col-4 form-group">
				<cfset bos_=0>
				<cfset dolu_=0>
				<cfif get_stock_locations.recordcount>
				<cfset bos_=100*bos/toplam>
				<cfset dolu_=100-bos_>
				</cfif>
					<div  style="height:25px;width:<cfif dolu_ neq 0>#dolu_#<cfelse>0</cfif>%;<cfif bos_ eq 0>border-radius:5px;<cfelse>border-top-left-radius: 5px;border-bottom-left-radius:5px;</cfif>background-color:##EF4836;">
						<div style="color:white;margin-top:6px;text-align: center;">%#TLFormat(dolu_,0)#</div>
					</div>
					<div style="height:25px;width:<cfif dolu_ neq 0>#bos_#<cfelse>100</cfif>%;<cfif dolu_ eq 0>border-radius:5px;<cfelse>border-top-right-radius: 5px;border-bottom-right-radius:5px;</cfif>background-color:##60C060;">
						<div style="color:white;margin-top:6px;text-align:center;">%#TLFormat(bos_,0)#</div>
					</div></div>
				</div>
			</div></cfoutput>
			</cf_box_search>
			</cf_box>
	</div>
	<cfoutput query="get_stock_locations" group="COMMENT">
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<cfquery name="get_count_" dbtype="query">
			SELECT * FROM get_stock_locations WHERE ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>
		<cfquery name="get_dolular_" dbtype="query">
			SELECT * FROM get_stock_locations WHERE  GIRIS > CIKIS and ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>
		<cf_box title="#COMMENT#   #TLFormat(get_dolular_.recordcount,0)#/#TLFormat(get_count_.recordcount,0)#">
			<cfoutput>
			<div class="col col-2 col-md-2 col-sm-2 col-xs-2"  style="height:3.82vw;width:3.82vw; !important;border:2px solid <cfif GIRIS gt cikis>##c93626;<cfelse>##55ad55</cfif>;text-align:center; font-weight:bold; font-size:11px; color:white; background:<cfif GIRIS gt cikis>##EF4836;<cfelse>##60C060</cfif>;">
				<b>#SHELF_CODE#</b>
			</div>
			</cfoutput>
	</cf_box>
	</div>
	</cfoutput>
</cfif>
	<script type="text/javascript">
		document.getElementById('keyword').focus();
		<cfif len(attributes.company_id)>
		degisim();
		</cfif>
		function degisim(){
		var company = document.getElementById("company_id").value;
		if(company!=-1){
		 get_department_id = wrk_query('SELECT DISTINCT * FROM  DEPARTMENT D,Branch B WHERE B.BRANCH_ID = D.BRANCH_ID AND B.COMPANY_ID ='+company,'dsn');
		var sel = document.getElementById('get_department_values');
		$("#get_department_values").empty();
		var opt = document.createElement('option');
		opt.innerHTML ="<cf_get_lang dictionary_id='58763.Depo'>";
		opt.value = "-1";
		sel.appendChild(opt);
		  }
		if(get_department_id.DEPARTMENT_HEAD.length!=0){
		for(var i = 0; i < get_department_id.DEPARTMENT_HEAD.length; i++) {
		var opt = document.createElement('option');
		opt.innerHTML = get_department_id.DEPARTMENT_HEAD[i];
		opt.value = get_department_id.DEPARTMENT_ID[i];
		sel.appendChild(opt);
		  }
		}
		get_department_id.DEPARTMENT_HEAD.length=0;
	}
	</script>