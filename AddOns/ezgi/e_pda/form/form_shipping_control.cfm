<cfsetting showdebugoutput="no">
<cfquery name="get_url" datasource="#dsn#">
	SELECT     
    	E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ADI
	FROM         
    	WRK_SESSION AS W INNER JOIN
     	EMPLOYEES AS E ON W.USERID = E.EMPLOYEE_ID
	WHERE     
    	W.ACTION_PAGE LIKE '#fuseaction#%' AND 
        W.ACTION_PAGE LIKE N'%ship_id=#attributes.ship_id#%' AND 
        E.EMPLOYEE_ID <> #session.ep.userid#
</cfquery>
<cfif get_url.recordcount>
	<cfset kullanici = get_url.adi>
	<script language="javascript">
		alert('<cf_get_lang_main no='3177.Girmek İstediğiniz Sayfa Kullanılmaktadır'>');
		history.back();
	</script>
</cfif>
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_SHIPPING_DEFAULTS
</cfquery>
<cfif not len(get_defaults.EAN)>
	<script language="javascript">
		alert('Default Tanımları Giriniz');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
         	(
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
         	FROM          
            	EZGI_SHIPPING_PACKAGE_LIST
         	WHERE      
            	TYPE = 1 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
        	) AS CONTROL_AMOUNT,
            SPECT_MAIN_ID
		FROM         
        	(
            SELECT
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                SPECT_MAIN_ID
           	FROM
            	(     
                SELECT     
                    SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) AS PAKET_SAYISI, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID
                FROM          
                    EZGI_SHIP_RESULT AS ESR INNER JOIN
                    EZGI_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    EZGI_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                WHERE      
                    ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                    ORR.ORDER_ROW_CURRENCY = -6
                GROUP BY 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    ORR.SPECT_VAR_ID
             	) AS TBL1
          	GROUP BY
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                SPECT_MAIN_ID
        	) AS TBL
  	</cfquery>
<cfelse>
   	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            (
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
           	FROM          
            	EZGI_SHIPPING_PACKAGE_LIST
        	WHERE      
            	TYPE = 2 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
          	) AS CONTROL_AMOUNT, 
            SHIP_RESULT_ID,
            SPECT_MAIN_ID
		FROM         
        	(
            SELECT     
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                SPECT_MAIN_ID
       		FROM          
            	(
                SELECT     
                	SUM(SIR.AMOUNT * EPS.PAKET_SAYISI) AS PAKET_SAYISI, 
                 	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID,
                    ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = SIR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID
         		FROM     
                	STOCKS AS S INNER JOIN
                  	EZGI_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                	#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                  	#dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID INNER JOIN
                  	ORDER_ROW AS ORR ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID
           		WHERE      
                	SI.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                    ORR.ORDER_ROW_CURRENCY = -6
             	GROUP BY 
                	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID,
                    SIR.SPECT_VAR_ID
           		) AS TBL1
         	GROUP BY 
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                SPECT_MAIN_ID
       		) AS TBL
    </cfquery>
</cfif> 
<!---<cfdump expand="yes" var="#GET_SHIP_PACKAGE_LIST#">
<cfabort>--->
<cfset spect_main_id_list = ValueList(GET_SHIP_PACKAGE_LIST.SPECT_MAIN_ID)>
<cfquery name="get_detail_package_list" dbtype="query">
	SELECT * FROM GET_SHIP_PACKAGE_LIST WHERE CONTROL_AMOUNT > 0
</cfquery>
<cfquery name="get_total_control" dbtype="query">
	SELECT sum(CONTROL_AMOUNT) as CONTROL_AMOUNT, sum(PAKETSAYISI) PAKETSAYISI FROM GET_SHIP_PACKAGE_LIST
</cfquery>
<cfif not len(get_total_control.CONTROL_AMOUNT)>
	<cfset get_total_control.CONTROL_AMOUNT = 0 >
</cfif>
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset stock_id_list = ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')>
<div style="width:290px">
<table cellpadding="1" cellspacing="1" align="left" class="color-border" width="100%">
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=pda.emptypopup_add_shipping_package&SHIP_ID=#attributes.ship_id#&department_id=#attributes.department_id#&date1=#attributes.date1#&date2=#attributes.date2#&page=#attributes.page#&kontrol_status=#attributes.kontrol_status#&is_type=#attributes.is_type#</cfoutput>">
	<tr class="color-list">
		<td colspan="4" style="width:100%">
		<table cellpadding="0" cellspacing="1" width="100%">
			<tr height="20px">
            	<td colspan="4">
					<cfif attributes.is_type eq 1><b>Sevk No :</b><cfelse><b><cf_get_lang_main no='3178.Sevk Talep No'> :</b></cfif><cfoutput><b>#attributes.DELIVER_PAPER_NO#</cfoutput></b>&nbsp;&nbsp;
                    <b>Ok: <cfoutput><input type="text" name="total_control_amount" readonly="readonly" class="box"  style="width:35px;text-align:right;color:FF0000; font-weight:bold" id="total_control_amount" value="" /> / #get_total_control.PAKETSAYISI#</b></cfoutput>
                </td>
           	</tr>
			<tr>
				<td><cf_get_lang_main no='223.Miktar'></td>
				<td><strong><input name="add_other_amount" type="text" value="<cfoutput>#attributes.add_other_amount#</cfoutput>" class="moneybox" style="width:40px;"></strong></td>
				<td nowrap="nowrap"><cf_get_lang_main no='170.Ekle'></td>                     
				<td><input name="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,add_other_amount.value,1);}" style="width:120px;"></td>
			</tr>
		</table>
		</td>
	</tr>
   	<tr class="color-list" height="20px">
    	<td><cf_get_lang_main no='809.Ürün Adı'></td>
        <td width="25px"><cf_get_lang_main no='3179.MKT.'></td>
        <td width="25px"><cf_get_lang_main no='3180.KNT.'></td>
        <td width="25px">OK</td>
    </tr>    
	<cfset product_barcode_list = ''>
	<input type="hidden" name="stock_id_list" value="<cfoutput>#stock_id_list#</cfoutput>">
	<cfoutput query="GET_SHIP_PACKAGE_LIST">
        <cfquery name="get_product_info" datasource="#dsn3#">
            SELECT  	PIP.PROPERTY7, 
                        PIP.PROPERTY13,
                        S.STOCK_CODE_2
            FROM       	STOCKS AS S LEFT OUTER JOIN
                        PRODUCT_INFO_PLUS AS PIP ON S.PRODUCT_ID = PIP.PRODUCT_ID
            WHERE     	(S.STOCK_ID = #STOCK_ID#)
        </cfquery>
        <tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
           	<td>#product_name#<cfif SPECT_MAIN_ID gt 0><font color="red"> - #SPECT_MAIN_ID#</font></cfif></td>        
                <input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="box" style="width:100;">
                <cfquery name="GET_BARCODE" datasource="#DSN3#">
                    SELECT TOP 1 BARCODE FROM  STOCKS_BARCODES WHERE STOCK_ID=#STOCK_ID#
                </cfquery>
                <cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,ValueList(GET_BARCODE.BARCODE),','))>	
            <td>
                <input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="box" style="width:25px;text-align:right;">
            </td>
            <td>
                <input type="text" id="control_amount#STOCK_ID#" name="control_amount#STOCK_ID#" readonly="yes" value="<cfif isdefined('control_amount#STOCK_ID#')>#Evaluate('control_amount#STOCK_ID#')#</cfif>" class="box"  style="width:25px;text-align:right;color:FF0000;">
          	</td>
            <td align="center" valign="middle">      
                <img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
                <img id="warning_#STOCK_ID#" name="warning_#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') eq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\warning.gif">
                <img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
            </td>
        </tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	<tr class="color-list">
		<td colspan="4" align="right">
        	<input type="button" value="<cfif not get_detail_package_list.recordcount>Kaydet<cfelse>Güncelle</cfif>" onClick="if(confirm('Kaydetmek İstediğinizden Eminmisiniz?')) kontrol(); else return false;">
           <input type="button" value="<cfoutput>#getLang('main',50)#</cfoutput>" name="vazgec" onclick="if(confirm('Kaydetmeden Çıkıyorsunuz!')) cik(); else return false;" /> 
    	</td>
	</tr>
	</form>
</table>
</div>
<script language="javascript">
document.getElementById('add_other_barcod').focus();
setTimeout("document.getElementById('add_other_barcod').select();",1000);	
function add_product_to_barkod(barcode,amount,type)
{	
	<cfoutput>
		var ship_id = #attributes.ship_id#;
		var is_type = #attributes.is_type#;
	</cfoutput>
	if(barcode.substr(0,1)=='j')//Bazı barkod okuyucular okuduktan sonra başına j harfi koyuyor kontrol için yapıldı
		barcode = barcode.substring(1,length(barcode));
	uzunluk = barcode.length;
	spect = 0;
	ean = <cfoutput>#get_defaults.EAN#</cfoutput>;
	if(uzunluk > ean)
	{
		spect = barcode.substring(ean,uzunluk);
		barcode = barcode.substring(0,ean);
	}
	var amount = filterNum(amount,0)
	if(spect > 0)
	{
		if(list_find('<cfoutput>#spect_main_id_list#</cfoutput>',spect,','))
		{
		}
		else
		{
			alert(spect+' Spect No <cf_get_lang_main no='3181.Bu Sevikatın Ürünü Değildir'>!');
			document.getElementById('add_other_barcod').value = '';
			document.getElementById('add_other_barcod').focus();
			return false;	
		}
	}
	if(list_find('<cfoutput>#product_barcode_list#</cfoutput>',barcode,','))
	{
		var new_sql = "SELECT TOP 1 STOCK_ID FROM STOCKS_BARCODES WHERE BARCODE = '"+barcode+"'";
		var get_product = wrk_query(new_sql,'dsn1');
			if(document.getElementById('control_amount'+get_product.STOCK_ID)==undefined)
				alert('<cf_get_lang_main no='3150.Ürün Barkodu Hatalı'>')		
			else
			{
				if(document.all.changed_stock_id.value != "")//daha önceden bir satır eklenmişse alan dolmuş demektir ve yeni eklenecek alan için satırı renklendiyoruz bir alt satırda
					eval('row'+document.all.changed_stock_id.value).style.background='<cfoutput></cfoutput>';
				if(type==1)//ekleme ise
				{		
					if((document.getElementById('control_amount'+get_product.STOCK_ID).value*1)-(amount*-1) > (document.getElementById('amount'+get_product.STOCK_ID).value*1))
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+' <cf_get_lang_main no='3182.Fazla Çıkış'>');
					else
					{
						document.getElementById('control_amount'+get_product.STOCK_ID).value = (document.getElementById('control_amount'+get_product.STOCK_ID).value*1)+(amount*1);
						document.all.total_control_amount.value=(document.all.total_control_amount.value*1)+(amount*1);
					}
					if(document.getElementById('control_amount'+get_product.STOCK_ID).value == document.getElementById('amount'+get_product.STOCK_ID).value)
						document.getElementById('row'+get_product.STOCK_ID).style.display='none';
				}			
				else if(type==0)//silme ise	
					if(document.getElementById('control_amount'+get_product.STOCK_ID).value == 0 || document.getElementById('control_amount'+get_product.STOCK_ID).value < 0)
						alert('<cf_get_lang_main no='3183.Çıkan Ürünlerin Sayısı 0 dan küçük olamaz'>');
					else		
						document.getElementById('control_amount'+get_product.STOCK_ID).value = (document.getElementById('control_amount'+get_product.STOCK_ID).value*1)-(amount*1);
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value == document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='none';}	
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value > document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='';}
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value < document.getElementById('amount'+get_product.STOCK_ID).value)
								eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
			document.all.add_other_barcod.value='';
			/*document.all.del_other_barcod.value='';*/
			document.all.changed_stock_id.value = get_product.STOCK_ID;
			eval('row'+get_product.STOCK_ID).style.background='FFCCCC';
			}	
		}
	else
		alert('<cf_get_lang_main no='3184.Kayıtlı Barkod Yok!'>')
}
function kontrol()
{

	for(i=1;i<=<cfoutput>#listlen(stock_id_list,',')#</cfoutput>;i++)
	{
		eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value = eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value
	}
	document.add_package.submit();
}
function cik()
{
	window.location ="<cfoutput>#request.self#?fuseaction=pda.list_shipping</cfoutput>";
}
</script>