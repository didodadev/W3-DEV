<!---iç talep süreç onaylandı değil ise satınalma siparişine dönüştürme butonunu gizler--->


<cfif caller.attributes.fuseaction eq 'sales.list_order' and caller.attributes.event eq 'upd'>
<script type="text/javascript">
function Yuklendi()
{

var divId =document.getElementById("transformation");
element="<a href='javascript://' onclick='addlink();' class='tableyazi'><img src='/images/canta.gif' alt='Numune görüntüle' border='0' title='Toplu Fiyat Güncelle'>";
divId.innerHTML+=element;
		
}
function addlink()
{
	var sql='select RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID='+'<cfoutput>#caller.attributes.order_id#</cfoutput>';
	
	rows=wrk_query(sql,'dsn3');
	if(rows.recordcount > 0)
	{
	var req_id=rows.RELATED_ACTION_ID;
	window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=det&req_id='+req_id,'page');
	}
	else
	alert('İlişkili Numune Kaydı Yok!');
}
window.onload = Yuklendi;
</script>
</cfif>