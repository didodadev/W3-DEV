<cfif caller.attributes.fuseaction eq 'sales.list_order' and caller.attributes.event eq 'upd'>
<script type="text/javascript">
function Yuklendi()
{

var divId =document.getElementById("transformation");
element="<a href='javascript://' onclick='addlink();' class='tableyazi'><img src='/images/workdevanalys.gif' alt='Numune görüntüle' border='0' title='Numune görüntüle'>";
divId.innerHTML+=element;
		
}
function addlink()
{
	var sql="select TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID="+"<cfoutput>#caller.attributes.order_id#</cfoutput>";
	
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

$(document).ready(function() {
var mkontrol = kontrol;
kontrol = function() {
	//parseInt($("#totalAmountList td.txtbold").next().text()) = miktarı verir
	//[...].indexOf($("#priority_id").val()) priority id leri
	//[...].indexOf($("#process_stage").val()) süreç id leri

	if (parseInt($("#totalAmountList td.txtbold").next().text()) > 5 && ["2","5","6","7","8","9","10","11","13"].indexOf($("#priority_id").val()) >= 0 && ["109", "122"].indexOf($("#process_stage").val()) >= 0) {
		alert("Bu kategoride en fazla 5 adet sipariş girebilirsiniz.");
		return false;
	} else if (parseInt($("#totalAmountList td.txtbold").next().text()) > 20 && ["1","12"].indexOf($("#priority_id").val()) >= 0 && ["109", "122"].indexOf($("#process_stage").val()) >= 0) {
		alert("Bu kategoride en fazla 20 adet sipariş girebilirsiniz.");
		return false;
	}  
	  else if (parseInt($("#totalAmountList td.txtbold").next().text()) > 0 && ["4"].indexOf($("#priority_id").val()) >= 0 && ["109", "122"].indexOf($("#process_stage").val()) >= 0) {
		alert("Bu kategoride sipariş veremezsiniz.");
		return false;
	} else {
		return mkontrol();
	}
}

});
</script>
</cfif>