<cfif caller.active_table_draw_type eq 1>
	<cfif caller.is_auto_sheet_break eq 0>
		<cfset caller.sheet_ = caller.sheet_ + 1>
		<cfset caller.newSheet = caller.workBook.createSheet()/>
		<cfset caller.workBook.setSheetName(caller.sheet_, "Yeni Excel Sistemi #caller.sheet_#")/>
		<cfset printSetup = caller.newSheet.getPrintSetup()>
		<cfset caller.newSheet.setMargin(0,0)>
		<cfset caller.newSheet.setMargin(1,0)>
		<cfset caller.newSheet.setMargin(2,0)>
		<cfset caller.newSheet.setMargin(3,0)>		
		<cfset caller.sutun_sayisi = 0>
		<cfset caller.tr_satir_sayisi = 0>
	<cfelse>
	</cfif>
</cfif>
