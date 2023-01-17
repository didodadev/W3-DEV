<cftransaction>
    <cfquery name="del_rota" datasource="#dsn3#">
        DELETE FROM EZGI_DESIGN_PIECE_ROTA WHERE PIECE_ROW_ID = #attributes.piece_id#
    </cfquery>
</cftransaction>
<script type="text/javascript">
	alert('Operasyonlar Silinmiştir.');
  	window.close();
</script>