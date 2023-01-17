<!---
	upd : 30092020 
	1 Akbank
	2 Fortis
	3 İş Bankası
	4 Deniz Bank
	5 Finansbank
	6 HSBC
	7 Vakıfbank
	8 Garanti
	9 YapıKredi
	10 Halkbank
	11 Türkiye Finans
	12 Bank Asya
	13 Citi Bank
	14 TEB
	15 Ziraat
	16 ING Bank
	17 Odea Bank
	18 Şekerbank
	20 Albaraka Türk
--->
<cfquery name="GET_POS_RELATION" datasource="#dsn#">
	SELECT 
		POS_REL.POS_ID,
		POS_REL.OUR_COMPANY_ID,
		POS_REL.USER_NAME,
		POS_REL.CLIENT_ID,
		COMP.COMPANY_NAME,
		POS_REL.POS_TYPE,
		POS_REL.IS_SECURE,
		POS_REL.IS_ACTIVE,
		POS_REL.POS_NAME,
		POS_REL.DETAIL
	FROM 
		OUR_COMPANY_POS_RELATION AS POS_REL,
		OUR_COMPANY AS COMP
	WHERE
		COMP.COMP_ID = POS_REL.OUR_COMPANY_ID
		AND POS_REL.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMP.COMPANY_NAME
</cfquery>

<cfset pos_relation = structNew()>
<cfoutput query="GET_POS_RELATION">
	<cfset pos_relation[POS_TYPE] = POS_ID >
</cfoutput>

<cf_box title="#getLang('','Ödeme Kuruluşları',61265)#" scroll="0">
	<div class="ui-dashboard ui-dashboard_type2">
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,1)><cfoutput>#pos_relation[1]#,1</cfoutput><cfelse>'',1</cfif>)">
				<img src="/images/bankslogo/Akbank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="padding: 0px 0!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,13)><cfoutput>#pos_relation[13]#,13</cfoutput><cfelse>'',13</cfif>)">
				<img src="/images/bankslogo/citibank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="padding: 10px 25px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,4)><cfoutput>#pos_relation[4]#,4</cfoutput><cfelse>'',4</cfif>)">
				<img src="/images/bankslogo/Denizbank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,8)><cfoutput>#pos_relation[8]#,8</cfoutput><cfelse>'',8</cfif>)">
				<img src="/images/bankslogo/Garanti.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,10)><cfoutput>#pos_relation[10]#,10</cfoutput><cfelse>'',10</cfif>)">
				<img src="/images/bankslogo/Halkbank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,6)><cfoutput>#pos_relation[6]#,6</cfoutput><cfelse>'',6</cfif>)">
				<img src="/images/bankslogo/Hsbc.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,16)><cfoutput>#pos_relation[16]#,16</cfoutput><cfelse>'',16</cfif>)">
				<img src="/images/bankslogo/Ing.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="padding: 20px 25px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,3)><cfoutput>#pos_relation[3]#,3</cfoutput><cfelse>'',3</cfif>)">
				<img src="/images/bankslogo/IsBankasi.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="padding: 20px 25px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,17)><cfoutput>#pos_relation[17]#,17</cfoutput><cfelse>'',17</cfif>)">
				<img src="/images/bankslogo/Odeabank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,5)><cfoutput>#pos_relation[5]#,5</cfoutput><cfelse>'',5</cfif>)">
				<img src="/images/bankslogo/FinansBank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="margin: -14px 0px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,18)><cfoutput>#pos_relation[18]#,18</cfoutput><cfelse>'',18</cfif>)">
				<img src="/images/bankslogo/SekerBank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="padding: 14px 25px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,15)><cfoutput>#pos_relation[15]#,15</cfoutput><cfelse>'',15</cfif>)">
				<img src="/images/bankslogo/Ziraatbank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,20)><cfoutput>#pos_relation[20]#,20</cfoutput><cfelse>'',20</cfif>)">
				<img src="/images/bankslogo/Albaraka.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="margin: 10px 0px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,7)><cfoutput>#pos_relation[7]#,7</cfoutput><cfelse>'',7</cfif>)">
				<img src="/images/bankslogo/Vakıfbank.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center" style="margin: -10px 0px!important;">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,9)><cfoutput>#pos_relation[9]#,9</cfoutput><cfelse>'',9</cfif>)">
				<img src="/images/bankslogo/YapıKredi.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,14)><cfoutput>#pos_relation[14]#,14</cfoutput><cfelse>'',14</cfif>)">
				<img src="/images/bankslogo/TEB.png">
			</a>
		</div>
		<div class="col-2 col-sm-3 col-md-2 col-xs-4 text-center">
			<a href="javascript://" onclick="openModal(<cfif structKeyExists(pos_relation,11)><cfoutput>#pos_relation[11]#,11</cfoutput><cfelse>'',11</cfif>)">
				<img src="/images/bankslogo/TurkiyeFinans.png">
			</a>
		</div>
	</div>
</cf_box>
<cf_box title="#getLang('','Entegre Olunan Poslar',64690)#">
	<cf_grid_list>
		<thead>
			 <tr> 
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='61265.Ödeme Kuruluşları'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='42352.Sanal Pos'></th>
				<th width="60"><cf_get_lang dictionary_id='42882.Davranış'></th>
				<th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="50"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="20"><a href="javascript://" onclick="cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_pos_relation&event=add', 'warning_modal')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_pos_relation.recordcount >
				<cfoutput query="GET_POS_RELATION"> 
					<tr>  
						<td>#currentrow#</td>
						<td>
							<cfif pos_type eq 1><cf_get_lang dictionary_id="42547.Akbank">
							<cfelseif pos_type eq 2>N Kolay
							<cfelseif pos_type eq 3><cf_get_lang dictionary_id="42673.İş Bankası">
							<cfelseif pos_type eq 4><cf_get_lang dictionary_id="42701.Deniz Bank">
							<cfelseif pos_type eq 5><cf_get_lang dictionary_id="42702.Finansbank">
							<cfelseif pos_type eq 6><cf_get_lang dictionary_id="42703.HSBC">
							<cfelseif pos_type eq 7><cf_get_lang dictionary_id="42718.Vakıfbank">
							<cfelseif pos_type eq 8><cf_get_lang dictionary_id="57717.Garanti">
							<cfelseif pos_type eq 9><cf_get_lang dictionary_id="42723.YapıKredi">
							<cfelseif pos_type eq 10><cf_get_lang dictionary_id="42726.Halkbank">
							<cfelseif pos_type eq 11><cf_get_lang dictionary_id="42729.Türkiye Finans">
							<cfelseif pos_type eq 12><cf_get_lang dictionary_id="42733.Bank Asya">
							<cfelseif pos_type eq 13><cf_get_lang dictionary_id="42753.Citi Bank">
							<cfelseif pos_type eq 14><cf_get_lang dictionary_id="48729.TEB">
							<cfelseif pos_type eq 15><cf_get_lang dictionary_id="42759.Ziraat">
							<cfelseif pos_type eq 16><cf_get_lang dictionary_id="42764.ING Bank">
							<cfelseif pos_type eq 17><cf_get_lang dictionary_id='65280.Odea Bank'>
							<cfelseif pos_type eq 18><cf_get_lang dictionary_id='51551.Şekerbank'>
							<cfelseif pos_type eq 20><cf_get_lang dictionary_id='65281.Albaraka'>
							</cfif>
						</td>	
						<td>#company_name#</td>
						<td><a href="javascript://" class="tableyazi" onClick="openModal('#pos_id#','#pos_type#')">#pos_name#</a></td>							
						<td><cfif is_secure eq 1><cf_get_lang dictionary_id='42363.3D Secure'><cfelse><cf_get_lang dictionary_id='42362.Normal'></cfif></td>
						<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						<td>#detail#</td>
						<!-- sil -->
						<td>
							<a href="javascript://" onclick="openModal('#pos_id#','#pos_type#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</td>
						<!-- sil --> 
					</tr>
				</cfoutput> 
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
 <script>
	function openModal(key, posid){
		if( key != '' )
			cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_pos_relation&event=upd&pos_id='+key, 'warning_modal');
		else
			cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_pos_relation&event=add&pos_type='+posid, 'warning_modal');
	}
</script>