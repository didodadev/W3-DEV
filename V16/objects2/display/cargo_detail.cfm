<style type="text/css">
	.cargo_list
	{
		border-collapse: collapse;
		text-align: left;
		border:none;
	}
	.cargo_list thead tr {
		background-color:#E8E8E8;	
	}
	.cargo_list th {
	
		font-weight:bold;
		color: #039;
		padding:2px;
	
	}
	.cargo_list td
	{
		color: #669;
		padding:2px;
		border-top:1px solid #999;
	}
	.cargo_list tbody tr:hover
	{
		color: #009;
		background-color:#0000;
	}
</style>
<cfsavecontent variable="loginInfo">
	<LoginInfo>
        <UserName>est1923</UserName>
        <Password>779</Password>
        <CustomerCode>908308201219</CustomerCode>
	</LoginInfo>
</cfsavecontent>
<cfoutput>
<cfsavecontent variable="queryInfo">
	<QueryInfo>
		<QueryType>1</QueryType>
		<IntegrationCode>#attributes.ref_no#</IntegrationCode>
	</QueryInfo>
</cfsavecontent>
<cfsavecontent variable="queryInfo_detail">
	<QueryInfo>
		<QueryType>9</QueryType>
		<IntegrationCode>#attributes.ref_no#</IntegrationCode>
	</QueryInfo>
</cfsavecontent>
</cfoutput>

<cftry>
    <cfinvoke webservice="http://customerservices.araskargo.com.tr/ArasCargoCustomerIntegrationService/ArasCargoIntegrationService.svc?wsdl" method="GetQueryXML" returnvariable="ws" >
        <cfinvokeargument name="loginInfo" value="#loginInfo#">
        <cfinvokeargument name="queryInfo" value="#queryInfo#">
    </cfinvoke>
    <cfinvoke webservice="http://customerservices.araskargo.com.tr/ArasCargoCustomerIntegrationService/ArasCargoIntegrationService.svc?wsdl" method="GetQueryXML" returnvariable="ws_detail" >
        <cfinvokeargument name="loginInfo" value="#loginInfo#">
        <cfinvokeargument name="queryInfo" value="#queryInfo_detail#">
    </cfinvoke>
    <cfcatch>
        <table>
            <tr>
	            <td>Şuanda kargo detayına ulaşılamıyor. Lütfen daha sonra tekrar deneyiniz.</td>
            </tr>
        </table>
    </cfcatch>
</cftry>

<cftry>
<cfscript>

	xml_data = xmlparse(ws);
	kargo_takip_no = xml_data.QueryResult.Cargo.KARGO_TAKIP_NO.XmlText;
	varis_subesi = xml_data.QueryResult.Cargo.VARIS_SUBE.XmlText;
	paket_adedi = xml_data.QueryResult.Cargo.ADET.XmlText;
	durum = xml_data.QueryResult.Cargo.DURUMU.XmlText;
	alici = xml_data.QueryResult.Cargo.ALICI.XmlText;
	cikis_tarihi = xml_data.QueryResult.Cargo.CIKIS_TARIH.XmlText;

	xml_detail_data = xmlparse(ws_detail);
	xmlsize = arraylen(xml_detail_data.QueryResult.CargoTransaction);
	for(a=1;a LTE xmlsize;a++)
	{
		"islem_tarihi_#a#" = xml_detail_data.QueryResult.CargoTransaction[a].ISLEM_TARIHI.XmlText;
		"birim_#a#" = xml_detail_data.QueryResult.CargoTransaction[a].BIRIM.XmlText;
		"islem_#a#" = xml_detail_data.QueryResult.CargoTransaction[a].ACIKLAMA.XmlText;
	}
</cfscript>

<table class="cargo_list">
	<thead>
		<td><b>DETAY</b></td>
		<td><b>KARGO TAKİP NO</b></td>
		<td><b>VARIŞ ŞUBESİ</b></td>
		<td><b>PAKET ADET</b></td>
		<td><b>DURUM</b></td>
		<td><b>ALICI</b></td>
		<td><b>ÇIKIŞ TARİHİ</b></td>
	</thead>
	<cfoutput>
	<tbody>
		<td onclick="show_detail();">
			<img id="hide_product_detail" src="/images/arrow_up.png" title="Detay Gizle" style="display:none">
			<img id="show_product_detail" src="/images/arrow_down.png" title="Detay Göster">
		</td>
		<td>#kargo_takip_no#</td>
		<td>#varis_subesi#</td>
		<td style="text-align:right;">#paket_adedi#</td>
		<td>#durum#</td>
		<td>#alici#</td>
		<td>#left(cikis_tarihi,10)# #right(cikis_tarihi,5)#</td>
	</tbody>
	<tr>
		<td colspan="7">
			<table id="detail_table" style="display:none;width:100%">
			<thead>
				<td><b>İşlem Tarihi</b></td>
				<td><b>Birim</b></td>
				<td><b>İşlem</b></td>
			</thead>
			<cfloop from="1" to="#xmlsize#" index="index">
				<tbody>
					<td>#left(evaluate("islem_tarihi_#index#"),10)# #mid(evaluate("islem_tarihi_#index#"),12,5)#&nbsp;&nbsp;</td>
					<td>#evaluate("birim_#index#")#&nbsp;&nbsp;</td>
					<td>#evaluate("islem_#index#")#&nbsp;&nbsp;</td>
				</tbody>
			</cfloop>
			</table>
		</td>
	</tr>
	</cfoutput>
</table>
<script type="text/javascript">
	function show_detail()
	{
		if(document.getElementById('detail_table').style.display == '')
		{
			document.getElementById('detail_table').style.display = "none";
			document.getElementById('show_product_detail').style.display = "";
			document.getElementById('hide_product_detail').style.display = "none";
			hide_product_detail
		}
		else
		{
			document.getElementById('detail_table').style.display = "";
			document.getElementById('hide_product_detail').style.display = "";
			document.getElementById('show_product_detail').style.display = "none";
		}
	}	
</script>
<cfcatch>
    	<table>
        	<tr>
    	  		<td>Siparişiniz Faturalandırıldı ve Kargoya Verildi !</td>
            </tr>
        </table>
    </cfcatch>
</cftry>
