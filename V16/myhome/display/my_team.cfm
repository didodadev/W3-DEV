<!--- Örnek Kullanım Py 
	<cf_box id="myTeamDiv" closable="0"  collapsable="0" title="#getLang('myhome','',61177,'Ekibim')#" widget_load="myTeam">--->
<cf_catalystHeader>
<cfset myObj = createObject("component","V16.myhome.cfc.my_team") />
<cfset MyTeam = myObj.get_team(session.ep.position_code) />
<div class="ui-row">
	<div class="col col-4 col-xs-12 uniqueRow">
		<cf_box id="myTeamDiv" closable="0"  collapsable="1" title="#getLang('myhome','',61177,'Ekibim')#" widget_load="myTeam">
		</cf_box>
	</div>			
	<cfsavecontent  variable="txt">
		<cfoutput>
			#getLang('myhome','',61182,'Departmanlarım')# 
		</cfoutput>
	</cfsavecontent>			
	<div class="col col-8 col-xs-12 uniqueRow">
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box  id="myDepartmentsDiv" closable="0"  collapsable="1" title="#txt#" widget_load="myDepartments"></cf_box>
			<cf_box id="travelDiv" closable="0"  collapsable="1" title="Seyahat-İzin-Eğitim" widget_load="TravelOfftimeTraining"></cf_box>
			<cf_box  id="warningsDiv" closable="0"  collapsable="1" title="#getLang('myhome','',32507,'Onay ve uyarılar')#" widget_load="myProcess"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="budgetDiv" closable="0"  collapsable="1"  title="#getLang('myhome','',57559,'Bütçe')#" widget_load="MyBudgetStatus"></cf_box>	
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="purchaseStatusDiv" closable="0" collapsable="1" title="#getLang('myhome','',61178,'Satınalma Gündemi')#" widget_load="MyPurchaseStatus"></cf_box>	
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="contractStatusDiv" closable="0" collapsable="1" title="#getLang('myhome','',61180,'Sözleşme Gündemi')#" widget_load="MyActiveContracts"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="salesStatusDiv" closable="0"  collapsable="1" title="#getLang('myhome','',30841,'Satış Gündemi')#" widget_load="MySalesStatus"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="worksDiv" closable="0"  collapsable="1" title="#getLang('myhome','',57416,'proje')#" widget_load="MyProjects"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="callcenterDiv" closable="0"  collapsable="1" title="#getLang('myhome','',57438,'Callcenter')#" widget_load="MyCallCenter"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="serviceGuarantyDiv" closable="0"  collapsable="1" title="#getLang('myhome','',61181,'Servis garanti')#" widget_load="MyServiceGuarantee"></cf_box>
		</div>
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box id="MyTasksDiv" closable="0"  collapsable="1" title="#getLang('myhome','',31030,'Görevler')#" widget_load="MyTasks"></cf_box>
		</div>
	</div>	
</div>