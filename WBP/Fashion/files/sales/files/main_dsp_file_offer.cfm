
<cfif caller.attributes.fuseaction eq 'sales.list_offer' and caller.attributes.event eq 'upd'>
<script type="text/javascript">
function Yuklendi()
{

var divId =document.getElementById("transformation");
element="<a href='javascript://' onclick='addstock();'><img src='/images/assortment.gif' alt='Asorti Stoklar' border='0' title='Stok Kartı Aç'></a>";
element2="<a href='javascript://' onclick='addorder();'><img src='/images/workdevanalys.gif' alt='Asorti Sipariş' border='0' title='Asorti Sipariş Oluştur'></a>";
divId.innerHTML+=element;
divId.innerHTML+=element2;
		
}
function addstock()
{
	var sql="select TOP 1 RELATED_ACTION_ID,PRODUCT.PRODUCT_ID,PRODUCT.PRODUCT_CODE from OFFER_ROW,PRODUCT WHERE  OFFER_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND OFFER_ID="+"<cfoutput>#caller.attributes.offer_id#</cfoutput>";
	
	rows=wrk_query(sql,'dsn3');
	if(rows.recordcount > 0)
	{
	var req_id=rows.RELATED_ACTION_ID;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=add_stock&pid='+rows.PRODUCT_ID+'&pcode='+rows.PRODUCT_CODE+'&req_id='+req_id,'page');

	}
	else
	alert('İlişkili Numune Kaydı Yok!');
}
function addorder()
{
	var sql="select TOP 1 RELATED_ACTION_ID,PRODUCT_ID,OFFER.COMPANY_ID,OFFER.PARTNER_ID,OFFER.PROJECT_ID from OFFER_ROW,OFFER WHERE OFFER.OFFER_ID=OFFER_ROW.OFFER_ID AND RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND OFFER_ROW.OFFER_ID="+"<cfoutput>#caller.attributes.offer_id#</cfoutput>";
	
	rows=wrk_query(sql,'dsn3');
	if(rows.recordcount > 0)
	{
	var req_id=rows.RELATED_ACTION_ID;
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.product_plan&event=add_order_assortment&pid='+rows.PRODUCT_ID+'&req_id='+req_id+'&project_id='+rows.PROJECT_ID+'&company_id='+rows.COMPANY_ID+'&partner_id='+rows.PARTNER_ID+'&pcode=','page');

	}
	else
	alert('İlişkili Numune Kaydı Yok!');
}
window.onload = Yuklendi;
</script>
</cfif>
