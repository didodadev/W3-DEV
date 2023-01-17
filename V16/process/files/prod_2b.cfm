<cfif fuseaction contains 'upd_'>
	<script type="text/javascript">
	function addLoadEvent(func)
	{
		var oldonload = window.onload;
		if (typeof window.onload != 'function')
		{
			window.onload = func;
		}
		else
		{
			window.onload = function() 
			{
				if (oldonload)
				{
					oldonload();
				}
				func();
			}
		}
	}
	
	addLoadEvent
	(
		function bbb() 
		{
			document.form_upd_product.product_status.disabled = true;
		}
	);
	
	function process_cat_dsp_function()
	{
		document.form_upd_product.product_status.disabled = false;
		return true;
	}
	</script>
</cfif>
