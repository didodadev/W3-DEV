<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Pınar Yıldız		Developer	: Pınar Yıldız
Analys Date : 01/06/2016		Dev Date	: 01/06/2016
Description :

	* Bu controller Ürün Kategorilerini içerir.
	
	* add,upd ve list eventlerini içerisinde barındırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->
<cf_get_lang_set module_name="product">
<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor --->
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add',attributes.event)>
	<!--- Ust kategorisine bakarak tanimlarda kategori isminin olması engelleniyor. BK 20071003  --->
	<!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
    <cfif isdefined('attributes.hierarchy')>
        <cfquery name="GET_PRODUCTS" datasource="#DSN3#">
            SELECT HIERARCHY FROM PRODUCT_CAT,PRODUCT WHERE PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
        </cfquery>
        <cfif get_products.recordcount>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no='250.Bu Kategoride Ürün Tanımlı Oldugu için Alt Kategori Açamazsınız !'> !"});
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat#"> AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#.%">
    </cfquery>
    <cfif get_product_cat.recordcount>
        <script type="text/javascript">
           alertObject({message: "<cf_get_lang no ='884.Üst Kategori Altında Bu Kategori Tanımı Var! Başka Bir Kategori Tanımlayınız'>"});
        </script>
        <cfabort>
    </cfif>
    <cfset list = "',""">
    <cfset list2 = " , ">
    <cfset attributes.product_cat = replacelist(attributes.product_cat,list,list2)>
    <!--- image kontrol --->
    <cfif isDefined("attributes.image_cat") and len(attributes.image_cat)>
        <cftry>
            <cffile action="upload" filefield="image_cat" destination="#upload_folder#"  mode="777" nameconflict="MAKEUNIQUE">
            <cfset file_name = createUUID()>
            <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
            <cfset assetTypeName = listlast(cffile.serverfile,'.')>
            <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
            <cfif listfind(blackList,assetTypeName,',')>
                <cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
                <script type="text/javascript">
                    alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
            <cfset attributes.image_cat = '#file_name#.#cffile.serverfileext#'>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang_main no ='43.Dosyanız upload edilemedi! Dosyanızı kontrol ediniz'> !"});
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    </cfif>
    <!--- image kontrol --->
    <cfquery name="CHECK" datasource="#DSN1#">
        SELECT
            HIERARCHY
        FROM
            PRODUCT_CAT
        WHERE
            <cfif len(hierarchy)>
                HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#.#product_cat_code#">
            <cfelse>
                HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_cat_code#">
            </cfif>
    </cfquery>
    <cfif check.recordcount>
        <script type="text/javascript">
            alertObject({message: "<cf_get_lang no ='885.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !"});
        </script>
        <cfabort>
    </cfif>
    <cfscript>
		ProductCategoryModel.server_machine = fusebox.server_machine;
		add = ProductCategoryModel.add(
			hierarchy 				: attributes.hierarchy,
			product_cat_code 		: attributes.product_cat_code,
			list_order_no 		    : attributes.list_order_no,
			is_public				: iif(isdefined("attributes.is_public"),1,0),
			image_cat				: attributes.image_cat,
			is_customizable			: iif(isdefined("attributes.is_customizable"),1,0),
			is_installment_payment	: iif(isdefined("attributes.is_installment_payment"),1,0),
			del_photo				: iif(isdefined("attributes.del_photo"),1,0),
			product_cat				: attributes.product_cat,
			detail					: attributes.detail,
			profit_margin_min		: attributes.profit_margin_min,
			profit_margin_max		: attributes.profit_margin_max
		);
		attributes.actionId = add;
		addCompany = ProductCategoryModel.addCompanies(our_company_ids: attributes.our_company_ids);
		if(len(attributes.record_num_responsible) and attributes.record_num_responsible neq 0)
		{	for(i = 1;i lte attributes.record_num_responsible;i=i+1)
			{
				add = ProductCategoryModel.addResponsibles(
					position_code	: evaluate("attributes.position_code#i#"),
					order_number	: evaluate("attributes.order_number#i#")
				);
			}
		}
		if(len(attributes.rowCount_Brand) and attributes.rowCount_Brand neq 0)
		{	for(i = 1;i lte attributes.rowCount_Brand;i=i+1)
			{
				add = ProductCategoryModel.addBrand(
					brand_id	: evaluate("attributes.brand_id_#i#")
				);
			}
		}
	 </cfscript>
</cfif>
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('upd,det',attributes.event) and isdefined("attributes.product_cat")>
	<!--- Ust kategorisine bakarak tanimlarda kategori isminin olması engelleniyor. BK 20071003  --->
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT
        FROM
            PRODUCT_CAT
        WHERE
            PRODUCT_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat#"> AND
            HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#.%"> AND
            PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
    </cfquery>
    <cfif get_product_cat.recordcount>
        <script type="text/javascript">
            alertObject({message: "<cf_get_lang no ='884.Üst Kategori Altında Bu Kategori Tanımı Var! Başka Bir Kategori Tanımlayınız'>"});
        </script>
        <cfabort>
    </cfif>
    <cfset list="',""">
    <cfset list2=" , ">
    <cfset attributes.product_cat=replacelist(attributes.product_cat,list,list2)>
    <cfif isdefined("attributes.image_cat") and len(attributes.image_cat)>		
        <cfif len(attributes.old_image_cat)>
            <cf_del_server_file output_file="product/#attributes.old_image_cat#" output_server="#attributes.old_image_cat_server_id#">
        </cfif>		
        <cftry>
            <cffile action = "upload" filefield = "image_cat" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
            <cfcatch type="Any">
            <cfset error=1>
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>"});
                </script>
            </cfcatch>
        </cftry>
        <cfset file_name = createUUID()>
        <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
        <cfset attributes.file_name_image_cat = '#file_name#.#cffile.serverfileext#'>
    <cfelse>
    	<cfset attributes.file_name_image_cat = "">
    </cfif>
    <cfquery name="CHECK" datasource="#DSN1#">
        SELECT
            HIERARCHY
        FROM
            PRODUCT_CAT
        WHERE
            <cfif len(hierarchy)>
                HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#.#product_cat_code#"> AND
            <cfelse>
                HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_cat_code#"> AND
            </cfif>
            PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
    </cfquery>
    <cfif check.recordcount>
        <script type="text/javascript">
            alertObject({message: "<cf_get_lang no ='885.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !"});
        </script>
        <cfabort>
    </cfif>
    <!--- İlgili kategoriye ürün tanımlanmış mı ?--->
    <cfif not isdefined("attributes.product_cat")>
        <cfquery name="get_related_product" datasource="#DSN#">
           SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
        </cfquery>
        <cfif get_related_product.recordcount>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no='521.İlişkli ürün var'>"});
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfscript>
		ProductCategoryModel.server_machine = fusebox.server_machine;
		upd = ProductCategoryModel.upd(
			hierarchy 				: attributes.hierarchy,
			product_cat_code 		: attributes.product_cat_code,
			list_order_no 		    : attributes.list_order_no,
			is_public				: iif(isdefined("attributes.is_public"),1,0),
			image_cat				: attributes.image_cat,
			is_customizable			: iif(isdefined("attributes.is_customizable"),1,0),
			is_installment_payment	: iif(isdefined("attributes.is_installment_payment"),1,0),
			del_photo				: iif(isdefined("attributes.del_photo"),1,0),
			file_name_image_cat		: attributes.file_name_image_cat,
			product_cat				: attributes.product_cat,
			detail					: attributes.detail,
			profit_margin_min		: attributes.profit_margin_min,
			profit_margin_max		: attributes.profit_margin_max,
			product_catid			: attributes.product_catid
		);
		addCompany = ProductCategoryModel.addCompanies(our_company_ids: attributes.our_company_ids,product_catid	: attributes.product_catid);
		attributes.actionId = upd;
		if(len(attributes.record_num_responsible) and attributes.record_num_responsible neq 0)
		{	for(i = 1;i lte attributes.record_num_responsible;i=i+1)
			{
				add = ProductCategoryModel.addResponsibles(
					position_code	: evaluate("attributes.position_code#i#"),
					order_number	: evaluate("attributes.order_number#i#"),
					product_catid	: attributes.product_catid,
					is_del 			: iif(i eq 1,1,0)
				);
			}
		}
		if(len(attributes.rowCount_Brand) and attributes.rowCount_Brand neq 0)
		{	for(i = 1;i lte attributes.rowCount_Brand;i=i+1)
			{
				add = ProductCategoryModel.addBrand(
					brand_id		: evaluate("attributes.brand_id_#i#"),
					product_catid	: attributes.product_catid,
					is_del 			: iif(i eq 1,1,0)
				);
			}
		}
	 </cfscript>
</cfif>
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('del',attributes.event)>
	<cfscript>
		del = ProductCategoryModel.del(product_catid	: attributes.product_catid,oldhierarchy	: attributes.oldhierarchy);
		attributes.actionId = del;
	</cfscript>
</cfif>
<cfif  not isdefined('attributes.formSubmittedController')>
<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor bitiş--->
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>	
 	<cfset sayfa_ad = "list_product_cat_detail">
    <cfparam name="is_filtered" default="0">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.our_company" default="#session.ep.company_id#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>  
    <cfscript>
		getProductCatQuery = getProductCat.get(product_catid:0);
		getOurCompanyQuery = getOurCompany.get();
	</cfscript>
    <cfif isdefined("attributes.form_submitted")>
    	<cfscript>
			getProductCategory = ProductCategoryModel.get(
				cat 		    : attributes.cat,
				keyword			: attributes.keyword,
				class_category	: iif(isdefined("attributes.class_category") and len(attributes.class_category),de("attributes.class_category"),de('')),
				our_company		: attributes.our_company,
				categoryId		: 0			
			);
		</cfscript>
    <cfelse>
        <cfset getProductCategory.recordcount=0>
    </cfif>  
    <cfparam name="attributes.totalrecords" default="#getProductCategory.recordcount#">
<cfelseif IsDefined("attributes.event") and ListFindNoCase("add,upd,det",attributes.event)>	
    <cfif IsDefined("attributes.event") and listFind('upd,det',attributes.event)>
        <cfscript>
            getProductCategory = ProductCategoryModel.get(
                categoryId		: attributes.id		
            );
            attributes.hierarchy = getProductCategory.hierarchy;
            attributes.product_cat = getProductCategory.product_cat;
			attributes.profit_margin = getProductCategory.profit_margin;
            attributes.profit_margin_max = getProductCategory.profit_margin_max;
			attributes.list_order_no = getProductCategory.list_order_no;
			attributes.user_friendly_url = getProductCategory.user_friendly_url;
			attributes.detail = getProductCategory.detail;
			if(getProductCategory.is_public eq 1)
			attributes.is_public = getProductCategory.is_public;
			if(getProductCategory.is_customizable eq 1)
			attributes.is_customizable = getProductCategory.is_customizable;
			if(getProductCategory.is_installment_payment eq 1)
			attributes.is_installment_payment = getProductCategory.is_installment_payment;
			if(len(getProductCategory.IMAGE_CAT))
			attributes.del_photo = 1;
			attributes.image_cat = getProductCategory.image_cat;
			attributes.image_cat_server_id = getProductCategory.image_cat_server_id;
			attributes.our_comp_list ='';
			attributes.file_name_image_cat ='';
        </cfscript>
        <cfif isdefined("attributes.id")>
            <cfif not getProductCategory.recordcount>
                <cfset hata  = 11>
                <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1230.Urun Kaydı Bulunamadı'> !</cfsavecontent>
                <cfset hata_mesaj  = message>
                <cfinclude template="../dsp_hata.cfm">
                <cfabort>
            <cfelse>
                 <cfscript>
                    getRelatedBrand = getProductCatBrand.get(categoryId: attributes.id);
                    getProductCatRelCompanies = getProductCatCompanies.get(categoryId: attributes.id);
                    getResponsibles = getProductCatResponsibles.get(categoryId: attributes.id);
					getOurCompanyQuery = getOurCompany.get();
					getProductCatQuery = getProductCat.get(product_catid:0);
                </cfscript>
                <cfset attributes.our_comp_list = valuelist(getProductCatRelCompanies.our_company_id)>
            </cfif>
            <cfset attributes.cat_code=listlast(getProductCategory.hierarchy,".")>
            <cfset attributes.ust_cat_code=listdeleteat(getProductCategory.hierarchy,ListLen(getProductCategory.hierarchy,"."),".")>     
        </cfif>  
    <cfelse>
    	<cfscript>
			getProductCatQuery = getProductCat.get(
				product_catid:0
			);
			getOurCompanyQuery = getOurCompany.get();
			attributes.hierarchy = '';
			attributes.product_cat = '';
			attributes.profit_margin = '';
			attributes.profit_margin_max = '';
			attributes.list_order_no = '';
			attributes.user_friendly_url = '';
			attributes.detail = '';
			attributes.image_cat = '';
			attributes.image_cat_server_id ='';
			attributes.cat_code ='';
			attributes.ust_cat_code ='';
			attributes.our_comp_list= '';
			getResponsibles.recordcount = 0; 
			attributes.file_name_image_cat ='';
		</cfscript>
    </cfif>  
</cfif>

<script type="text/javascript">
	<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
		$( document ).ready(function() {
			$('#keyword').focus();
		});	
	<cfelseif IsDefined("attributes.event") and ListFindNoCase('add,upd,det',attributes.event)>
		
		function pencere_ac(row)
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=document.product_cat.brand_id_'+row+'&brand_name=document.product_cat.brand_name_'+row+'&keyword='+encodeURIComponent(eval('document.product_cat.brand_name_'+row+'.value')),'small'</cfoutput>);
		}
		
		function delRowBrand(yer)
		{
			document.getElementById("brand_id_" + yer).value=0;
			document.getElementById("frm_row" + yer).style.display="none";
		}
		
		function addRowBrand()
		{
			rowCount_Brand++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
			newRow.setAttribute("name","frm_row" + rowCount_Brand);
			newRow.setAttribute("id","frm_row" + rowCount_Brand);
			document.getElementById('rowcount_brand').value = rowCount_Brand;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a href="javascript://" onClick="delRowBrand(' + rowCount_Brand + ');"><img src="/images/delete_list.gif"  align="absbottom" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap')
			newCell.innerHTML =  '<input type="hidden" name="brand_id_' + rowCount_Brand +'" id="brand_id_' + rowCount_Brand +'"><input type="text" name="brand_name_' + rowCount_Brand +'" id="brand_name_' + rowCount_Brand +'" value="" readonly style="width:180px;">&nbsp;<a href="javascript://" onClick="pencere_ac(' + rowCount_Brand + ');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		}
		
	
		function add_responsible_row()// sonra düzenlenecek diyor emrah:p
			{
				responsible_row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table_responsible").insertRow(document.getElementById("table_responsible").rows.length);
				newRow.setAttribute("id","responsibles" + responsible_row_count);
				document.getElementById('record_num_responsible').value = responsible_row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="row_kontrol_responsibles' + responsible_row_count +'" id="row_kontrol_responsibles' + responsible_row_count +'" value="1"><a style="cursor:pointer" onclick="sil_responsible(' + responsible_row_count + ');"><img  src="images/delete_list.gif" border="0" alt="Sil"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="order_number' + responsible_row_count +'" id="order_number' + responsible_row_count +'" style="width:45px;" onkeyup="isNumber(this);" onblur="isNumber(this);">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="position_code' + responsible_row_count +'" id="position_code' + responsible_row_count +'"><input type="text" name="position_name' + responsible_row_count +'" id="position_name' + responsible_row_count +'" style="width:100px;"  value="" onFocus="AutoCompleteOpenPos(' + responsible_row_count + ');" > <a href="javascript://" onClick="PopupOpenPos('+ responsible_row_count +');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
				
			}
		function AutoCompleteOpenPos(row)
			{
				AutoComplete_Create('position_name'+row,'FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','position_code'+row,'','3','130');
			}
		function PopupOpenPos(row)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=product_cat.position_name' + row +'&field_code=product_cat.position_code' + row </cfoutput>,'list');
			}
		function sil_responsible(row)
			{
				$('row_kontrol_responsibles' + row).val(0);
				document.getElementById('responsibles' + row ).style.display = 'none';
			}
		<cfif IsDefined("attributes.event") and attributes.event is 'add'>
			$( document ).ready(function() {
				responsible_row_count = 0;
				rowCount_Brand = 0;
				money2_js = '#session.ep.money2#';	
				validate().set();		
			});
			function form_check()
			{ 
				formName = 'product_cat',  // scripttin en başına bir defa yazılacak
                form  = $('form[name="'+ formName +'"]'); // form'u seçer 

				if(form.find('select#our_company_ids').val()  == '' || form.find('select#our_company_ids').val()  == null)
				{
					alert("<cf_get_lang no ='190.Lütfen, kaydetmek istediğiniz kategoriyi en az bir şirket ile ilişkilendiriniz!'>");
					return false;
					// custom tag msg veremiyoruz !!!!!?
			     }
				
				for (i=1;i<responsible_row_count+1;i++)
				{
					if(form.find('input#row_kontrol_responsibles'+i).val() == 1){
						if($('#order_number'+ i).val() == '' || $('#position_code'+ i).val() == '')
						{
							alert('Lütfen Sorumluları Eksiksiz Giriniz');
							return false;
						} // burası form dışı kontrol
					}
				}
				
				temp_profit_margin_min = filterNum($('#profit_margin_min').val());
				temp_profit_margin_max = filterNum($('#profit_margin_max').val());
				if (temp_profit_margin_min!="" && temp_profit_margin_max!="" && (parseFloat(temp_profit_margin_min) > parseFloat(temp_profit_margin_max))){
					
						validateMessage('notValid',form.find('input#profit_margin_min'),0 ); 
						return false;
					
					}else{
					
						validateMessage('valid',form.find('input#profit_margin_min') );  
				
					}
				form.find('input#profit_margin_min').val(temp_profit_margin_min) ;
				form.find('input#profit_margin_max').val(temp_profit_margin_max) ;
				return true;	
			}		
		</cfif>	
		<cfif IsDefined("attributes.event") and listFind('upd,det',attributes.event) and isdefined("attributes.id")>
				<cfoutput>
				$( document ).ready(function() {
					responsible_row_count = '#getResponsibles.recordcount#';
					rowCount_Brand = '#getRelatedBrand.recordcount#';
					money2_js = '#session.ep.money2#';	
					validate().set();
				});
				</cfoutput>
					
			function control_old_list()
			{ 
			
				var new_our_company_list='';
				if(form.find('select#our_company_ids').val()  != '' || form.find('select#our_company_ids').val()  != null)
				{
					new_our_company_list = form.find('select#our_company_ids').val() ;
				}
				<cfloop list="#attributes.our_comp_list#" index="k">
					if(!list_find(new_our_company_list,<cfoutput>#k#</cfoutput>,',') )
					{
						var new_dsn3 = '<cfoutput>#dsn#_#k#</cfoutput>';
						var get_productcat = wrk_safe_query('prd_get_product_cat',new_dsn3,0,<cfoutput>#attributes.id#</cfoutput>);
						if (get_productcat.recordcount)
						{
							validateMessage('notValid',form.find('input#product_cat'),1 );
							return false;
						}
					}
				</cfloop>
				return true;
			}
			
			function form_check() 
			{ 
				formName = 'product_cat',  // scripttin en başına bir defa yazılacak
                form  = $('form[name="'+ formName +'"]'); // form'u seçer 
				// Sorumlu (form dışı)
				for (i=1;i<responsible_row_count+1;i++)
				{
					if(form.find('input#row_kontrol_responsibles'+i).val() == 1){
						
					if($('#order_number'+ i).val() == '' || $('#position_code'+ i).val() == '')
					{
						alert('Lütfen Sorumlu ve Sıra Numarasını Eksiksiz Giriniz');
						return false;
						// burası form dışı kontrol
					}
					}
				}
				temp_profit_margin_min = filterNum($('#profit_margin_min').val());
				temp_profit_margin_max = filterNum($('#profit_margin_max').val());
				if (temp_profit_margin_min!="" && temp_profit_margin_max!="" && (parseFloat(temp_profit_margin_min) > parseFloat(temp_profit_margin_max))){
					
						validateMessage('notValid',form.find('input#profit_margin_min'),0 ); 
						return false;
					
					}else{
					
						validateMessage('valid',form.find('input#profit_margin_min') );  
				
					}
				
				var element = form.find('input#image_cat');	
				var val = String(element.val());
				if(val != '')
				{
					control	= new RegExp(/(jpeg|jpg|gif|bmp|png)/ig);
					if(!control.test(val)){
						validateMessage('notValid', element);
						return false;
					
					}else{
							validateMessage('valid', element);	
						} 
				}
									
				if (form.find('input#product_cat_code').val() != form.find('input#product_cat_code_old').val())	
				{	
					if (confirm("<cf_get_lang no ='853.Kategori Kodunda Yaptığınız Değişiklik Stok Hiyerarşisinin Bozulmasına ve Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?")) 
					{
						form.find('input#profit_margin_min').val(temp_profit_margin_min) ;
						form.find('input#profit_margin_max').val(temp_profit_margin_max) ;
						return true;
					}	
					else 
						return false;
				}		
				else
				{
					form.find('input#profit_margin_min').val(temp_profit_margin_min) ;
					form.find('input#profit_margin_max').val(temp_profit_margin_max) ;
					return true;
				}
				return true;
			}	
		</cfif>		
	</cfif>
</script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn1; // Transaction icin yapildi.
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_cat';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_cat_detail.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_form_add_product_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/FormProductCategory.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_cat&event=det&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'product_cat';//enctype="multipart/form-data"
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'form_check() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_product_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/FormProductCategory.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';	
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_cat&event=det&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'getProductCategory';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'record_emp';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'product_cat';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
		
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'form_check() && control_old_list() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
    WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteUrl'] = '#request.self#?fuseaction=product.list_product_cat&event=del';
	
	if(IsDefined("attributes.event") && listFind('upd,det,del',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		if(not isdefined('attributes.formSubmittedController'))
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_product_cat&event=del&product_catid=#attributes.id#&oldhierarchy=#getProductCategory.hierarchy#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_cat';
	
	}
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '12;12';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'product.list_product_cat&event=det&id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.form_upd_product_cat';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'product/form/form_upd_product_cat.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and not listfind('add,list',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'productCategoryController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = "<cf_get_workcube_content action_type ='PRODUCT_CATID' action_type_id ='#attributes.id#' style='0'>";
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 2; // Ajax Page
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '#request.self#?fuseaction=product.add_upd_cat_property&id=#attributes.id#&ust_cat_code=#attributes.ust_cat_code#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['id'] = 'cat_property';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['title'] = '#lang_array.item[81]#';		
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 2; // Ajax Page
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '#request.self#?fuseaction=product.popupajax_product_quality_definition&product_cat_id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['id'] = 'quality_control_cat_type';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['title'] = 'Kalite Kontrol Tipleri';	
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['type'] = 2; // Ajax Page
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['file'] = '#request.self#?fuseaction=product.popupajax_product_quality_parameters&product_cat_id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['id'] = 'quality_control_parameter';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['title'] = 'Kalite Kontrol Parametreleri';		
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['type'] = 2; // Ajax Page
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['file'] = '#request.self#?fuseaction=product.popupajax_product_member_inspection_level&product_cat_id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['id'] = 'member_inspection_levels';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['title'] = 'Üye Muayene Seviyeleri';		
		}
	}
	
	
	if(isdefined("attributes.event") and listfind('det,upd',attributes.event))
	{
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();	
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[261]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_product_cat&event=add&link_type=1";	
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['controllerFileName'] = 'productCategoryController';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_CAT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_CATID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_cat_code','item-product_cat','our_company_ids']";
	
/*	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']['controllerFileName'] = 'productListProductCat';
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']['eventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']['tableName'] = 'PRODUCT_CAT';
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']['dataSourceName'] = WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'];
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']['settings'] = "['item-head_cat_code','item-product_cat','our_company_ids']";
	*/
</cfscript>