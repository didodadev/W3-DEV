<cf_get_lang_set module_name="service">
<cfif not isdefined('attributes.formSubmittedController')>
	<cfscript>
		get_guaranty_cat = getGuarantyCat.get();
	</cfscript>
</cfif>

<cfif not isdefined('attributes.formSubmittedController')>
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
        <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
        <cfparam name="attributes.page" default="1">
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
        <cfparam name="attributes.stock_id" default="">
        <cfparam name="attributes.product_name" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.belge_no" default="">
        <cfparam name="attributes.lot_no" default="">
        <cfparam name="attributes.category" default="">
        <cfif isdefined("attributes.form_submitted")>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                <cf_date tarih = "attributes.start_date">
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                <cf_date tarih = "attributes.finish_date">
            </cfif>
            <cfscript>
                GET_CONSUMER_GUARANTIES = GuarantyModel.list(
                    category 		: attributes.category,
                    stock_id 		: attributes.stock_id,
                    product_name	: attributes.product_name,
                    keyword			: attributes.keyword,
                    lot_no			: attributes.lot_no,
                    belge_no		: attributes.belge_no,	
                    start_date		: attributes.start_date,
                    finish_date		: attributes.finish_date,
                    startrow		: attributes.startrow,
                    maxrows			: attributes.maxrows
                );
            </cfscript>
        <cfelse>
            <cfset get_consumer_guaranties.query_count = 0 >
        </cfif>
        <cfparam name="attributes.totalrecords" default = "#get_consumer_guaranties.query_count#">       
    <cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'add')>
        <cfparam name="attributes.method" default="0">
        <cfparam name="attributes.is_purchase_sales" default="0">
        <cfparam name="attributes.in_out" default="0">
        <cfparam name="attributes.is_return" default="0">
        <cfparam name="attributes.is_rma" default="0">
        <cfparam name="attributes.is_service" default="0">
        <cfparam name="attributes.is_trash" default="0">
        <cfparam name="attributes.stock_id" default="">
        <cfparam name="attributes.product_name" default="">
        <cfparam name="attributes.department_id" default="">
        <cfparam name="attributes.location_id" default="">
        <cfparam name="attributes.location_name" default="">
        <cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
        <cfparam name="attributes.guarantycat_id" default="">
        <cfparam name="attributes.sale_start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
        <cfparam name="attributes.sale_guarantycat_id" default="">
        <cfparam name="attributes.update_time" default="">
        <cfparam name="attributes.lot_no" default="">
        <cfparam name="attributes.is_sale" default="0">
        <cfif attributes.event is 'add'>
            <cfparam name="attributes.method" default="0">
            <cfparam name="attributes.amount" default="">
            <cfparam name="attributes.ship_start_no" default="">
            <cfparam name="attributes.ship_start_text" default="">
            <cfparam name="attributes.ship_start_nos" default="">
        <cfelseif attributes.event is 'upd'>
            <cfscript>
                get_guaranty_detail = GuarantyModel.get(
                    guarantyId : attributes.id
                );
                
                attributes.is_purchase_sales = get_guaranty_detail.IS_PURCHASE;
                attributes.in_out = get_guaranty_detail.in_out;
                attributes.is_return = get_guaranty_detail.is_return;
                attributes.is_rma = get_guaranty_detail.is_rma;
                attributes.is_service = get_guaranty_detail.is_service;
                attributes.is_trash = get_guaranty_detail.is_trash;
                attributes.stock_id = get_guaranty_detail.stock_id;
                attributes.product_name = get_guaranty_detail.product_name;
                attributes.department_id = get_guaranty_detail.department_id;
                attributes.location_id = get_guaranty_detail.location_id;
                attributes.start_date = dateFormat(get_guaranty_detail.purchase_start_date,'dd/mm/yyyy');
                attributes.guarantycat_id = get_guaranty_detail.purchase_guaranty_catid;
                attributes.sale_start_date = dateFormat(get_guaranty_detail.sale_start_date,'dd/mm/yyyy');
                attributes.sale_guarantycat_id = get_guaranty_detail.sale_guaranty_catid;
                attributes.update_time = get_guaranty_detail.update_time;
                attributes.lot_no = get_guaranty_detail.lot_no;
                attributes.is_sale = get_guaranty_detail.is_sale;
                attributes.finish_date = dateFormat(get_guaranty_detail.PURCHASE_FINISH_DATE,'dd/mm/yyyy');
                attributes.sale_finish_date = dateFormat(get_guaranty_detail.SALE_FINISH_DATE,'dd/mm/yyyy');
                attributes.guaranty_id = attributes.id;
                attributes.old_seri_no = get_guaranty_detail.serial_no;
            </cfscript>
        </cfif>
    </cfif> 
    
    <script type="text/javascript">
        <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
            $(document).ready(function(){
                $('#keyword').focus();
            });
        <cfelseif isdefined("attributes.event") and attributes.event is 'add'>
            $(document).ready(function(){
                var formName = 'form_basket';
                    form  = $('form[name="'+ formName +'"]');
                kontrol(0);
            });
            function chk_form()
            {
                if(form.find("input#method:checked").val() == 0)
                {
                    if(form.find("input#ship_start_no").val() == '')
                    {
                        validateMessage('notValid',form.find('input#ship_start_no'));
                        return false;
                    }
                    else
                        validateMessage('valid',form.find('input#ship_start_no') );
                }
                else
                {
                    if(form.find("textarea#ship_start_nos").val() == '')
                    {
                        validateMessage('notValid',form.find('textarea#ship_start_nos'));
                        return false;
                    }
                    else
                        validateMessage('valid',form.find('textarea#ship_start_nos') );
                }
                return true;
            }
            
            function kontrol()
            {
                if(form.find("input#method:checked").val() == 1)
                {
                    form.find("div#item-ship_start_nos").css('display','');
                    form.find("div#item-ship_start_no").css('display','none');
                }
                else
                {
                    form.find("div#item-ship_start_nos").css('display','none');
                    form.find("div#item-ship_start_no").css('display','');
                }
                return true;
            }
        </cfif>
    </script> 
</cfif>  
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_add_serialno_guaranty&take=1&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/formGuaranty.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_guaranty';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'chk_form() && validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.popup_add_serialno_guaranty&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/formGuaranty.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_guaranty';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '&id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_basket';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_guaranty_detail';

	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_guaranty';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/list_guaranty.cfm';


	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE_GUARANTY_NEW';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'GUARANTY_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_name','item-emp_name']";
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3;

</cfscript>


<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif listFindNoCase('upd,add',attributes.event,',')>
    	<cfscript>
			if(len(attributes.guarantycat_id))
				getPurchaseGuarantyTime = getGuarantyTime.get(guarantyCatId : attributes.guarantycat_id);
			if(len(attributes.sale_guarantycat_id))
				getSaleGuarantyTime = getGuarantyTime.get(guarantyCatId : attributes.sale_guarantycat_id);
		</cfscript>
        
        <cfif len(attributes.start_date)>
            <cf_date tarih= "attributes.start_date">
            <cfif getPurchaseGuarantyTime.recordcount and len(getPurchaseGuarantyTime.GUARANTYCAT_TIME)>
                <cfset finish_date = date_add("m",getPurchaseGuarantyTime.GUARANTYCAT_TIME,attributes.start_date)>
            </cfif>
        </cfif>
        <cfif len(attributes.sale_start_date)>
            <cf_date tarih= "attributes.sale_start_date">
            <cfif getSaleGuarantyTime.recordcount and len(getSaleGuarantyTime.GUARANTYCAT_TIME)>
                <cfset sale_finish_date = date_add("m",getSaleGuarantyTime.GUARANTYCAT_TIME,attributes.sale_start_date)>
            </cfif>
        </cfif>
        
		<cfif attributes.event is 'upd'>
            <cfif not attributes.serial_no is attributes.old_seri_no>
                <cfscript>
                    serialNoControl = GuarantyModel.serialNoControl(
                        serialNo	: attributes.serial_no,
                        stockId		: attributes.stock_id
                    );
                </cfscript>
                <cfif serialNoControl.recordcount>
                    <script type="text/javascript">
                        alertObject({message: "<cf_get_lang_main dictionary_id='38066.Seçilen seri no kullanılmıştır.'>!"});
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
            <cfscript>
                upd = GuarantyModel.upd(
                    inOut 				: iif(isdefined("attributes.in_out"),1,0),
                    isPurchaseSales 	: attributes.is_purchase_sales,
                    isReturn			: iif(isdefined("attributes.is_return"),1,0),
                    isRma				: iif(isdefined("attributes.is_rma"),1,0),
                    isService			: iif(isdefined("attributes.is_service"),1,0),
                    isTrash				: iif(isdefined("attributes.is_trash"),1,0),
                    stockId				: attributes.stock_id,
                    serialNo			: attributes.serial_no,
                    lotNo				: attributes.lot_no,
                    departmentId		: attributes.department_id,
                    locationId			: attributes.location_id,
                    guarantyCatId		: attributes.guarantycat_id,
                    startDate			: attributes.start_date,
                    finishDate			: finish_date,
                    saleGuarantyCatId	: attributes.sale_guarantycat_id,
                    saleStartDate		: attributes.sale_start_date,
                    saleFinishDate		: sale_finish_date,
					guarantyId			: attributes.guaranty_id
                );
                attributes.actionId = attributes.guaranty_id;
            </cfscript>
        </cfif>
	<cfelseif attributes.event is 'add'>
		<cfset list_numbers = "">
        <cfset yer = 0>
        <cfset yer2 = 0>
        <cfset f1 = 0>
        <cfset f2 = 0>
        <cfset attributes.ship_start_no = replace(attributes.ship_start_no,'*','-','all')>
        <cfset uzunluk = len(attributes.ship_start_no)>
        <cfset str = attributes.ship_start_no>
        <cfset counter = attributes.amount>
        <cfif attributes.method eq 0>
            <cfset sayi = "">
            <!--- sayısal kısım bulunur --->
            <cfloop from="1" to="#uzunluk#" index="j">
                <cfset temp = mid(str,uzunluk-j+1,1)>
                <cfif isnumeric(temp)>
                    <cfif f1>
                        <cfset sayi =  "#temp##sayi#">
                    <cfelse>
                        <cfset f1 = 1>
                        <cfset sayi =  "#temp##sayi#">
                    </cfif>
                <cfelse>
                    <cfif len(sayi)>
                        <cfset yer =j>
                        <cfbreak>
                    <cfelse>
                        <cfset yer2 =j>
                    </cfif>
                </cfif>
            </cfloop>
            <cfif yer>
                <cfset start = left(str,len(str)-yer+1)>
            <cfelse>
                <cfset start = "">
            </cfif>
            <cfif len(sayi) and len(start)>
                <cfset len_str = len(str)>
                <cfset len_sayi = len(sayi)>
                <cfset len_start = len(start)>
                <cfset minus = len_str - len_sayi-len_start>
                 <cfif minus gt 0>
                    <cfset end = right(str, abs(minus))>
                 <cfelse>
                    <cfset end = "">
                 </cfif>	
            <cfelse>
                <cfset end = "">
            </cfif>
            <!--- // sayısal kısım bulunur --->
            <!--- sayısal kısım başındaki sıfırlar saklanır --->
            <cfset zero_count = 0>
            <cfset str_zero="">
            <cfset ilk = "">
            <cfif not len(sayi)>
                <cfset sayi = "0">
                <cfif len(yer2)>
                    <cfset ilk = left(str,yer2)>
                </cfif>
            </cfif>
            <cfset zero_count = 1>
            <cfset counter_ = len(sayi)>
            <cfloop from="1" to="#len(sayi)#" index="k">
                <cfif mid(sayi,counter_,1) eq 0>
                    <cfset zero_count = zero_count + 1>
                </cfif>
                <cfset counter_ = counter_ -1>
            </cfloop>
            <cfset zero_count = zero_count-1>
            <cfif (zero_count eq 1) and left(sayi, 1)>
                <cfset zero_count = 0>
            </cfif>
            <cfif zero_count neq 0>
                <cfloop from="1" to="#zero_count#" index="m">
                    <cfset str_zero = str_zero & "0">
                </cfloop>
            </cfif>
            <!--- //sayısal kısım başındaki sıfırlar saklanır --->
            
            <cfloop from="0" to="#counter-1#" index="i">
                <!---<cfset temp_sayi = '#str_zero##sayi#'>--->
                
                <cfset temp_sayi = "#sayi#">
                <cfif len(ilk)>
                    <cfset temp_sayi = "#ilk##temp_sayi#">
                </cfif>
                <cfif len(start)>
                    <cfset temp_sayi = "#start##temp_sayi#">
                </cfif>
                <cfif len(end)>
                    <cfset temp_sayi = "#temp_sayi##end#">
                </cfif>
                <cfif isdefined("attributes.ship_start_text") and len(attributes.ship_start_text)>
                    <cfset temp_sayi = "#temp_sayi##attributes.ship_start_text#">
                </cfif>
                <cfif listlen(list_numbers) and not listfind(list_numbers, temp_sayi, ',')>
                    <cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
                <cfelseif not listlen(list_numbers)>
                    <cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
                </cfif>		
                <cfset sayi = add_one(sayi)>
            </cfloop>
        <cfelse>
            <cfset attributes.ship_start_no = ListChangeDelims(replacelist(attributes.ship_start_nos,"#chr(13)##chr(10)#",";"),",",";")>
            <cfset counter = 0>
            <cfset list_numbers = listappend(list_numbers, attributes.ship_start_no, ',')>
        </cfif>
        <cfset list_numbers = ListDeleteDuplicates(list_numbers)>
        <cfset main_list_numbers = ''>
    	<cfif len(list_numbers)>
        	<cfset list_numbers = "'"&ListChangeDelims(list_numbers,"','",",")&"'">
            <cfscript>
				seri_cont = GuarantyModel.seriCont(seriNoList:list_numbers);
				
				if(len(seri_cont))
				{
					for(i=1;i<=len(list_numbers);i++)
					{
						if(!listFindNoCase(seri_cont,listgetat(list_numbers,i,','),','))
							main_list_numbers = listAppend(main_list_numbers,listgetat(list_numbers,i,','),',');
					}
				}
			</cfscript>
        </cfif>
        <cfif len(main_list_numbers)>
        	<cfloop list="#main_list_numbers#" index="k">
				<cfset my_seri_number = "#mid(k,2,len(k)-2)#">
                <cfscript>
					add = GuarantyModel.add(
						inOut 				: iif(isdefined("attributes.in_out"),1,0),
						isPurchaseSales 	: attributes.is_purchase_sales,
						isReturn			: iif(isdefined("attributes.is_return"),1,0),
						isRma				: iif(isdefined("attributes.is_rma"),1,0),
						isService			: iif(isdefined("attributes.is_service"),1,0),
						isTrash				: iif(isdefined("attributes.is_trash"),1,0),
						stockId				: attributes.stock_id,
						serialNo			: my_seri_number,
						lotNo				: attributes.lot_no,
						departmentId		: attributes.department_id,
						locationId			: attributes.location_id,
						guarantyCatId		: attributes.guarantycat_id,
						startDate			: attributes.start_date,
						finishDate			: finish_date,
						saleGuarantyCatId	: attributes.sale_guarantycat_id,
						saleStartDate		: attributes.sale_start_date,
						saleFinishDate		: sale_finish_date,
						updateTime			: attributes.update_time
					);
					attributes.actionId = attributes.guaranty_id;
				</cfscript>
			</cfloop>
        <cfelse>
			<script type="text/javascript">
                alertObject({message: "Seri Numaraları Kayıtlı!"});
            </script>
            <cfabort>
        </cfif>
	</cfif>
</cfif>