<!--- Fatura iptal edilmişse iptal chckboxı disable eder SM 20080707 --->

<!--- KULLANMADAN ONCE function process_cat_function_ FONKSIYONUNUN ID DEGERI DEGISTIRILMELIDIR --->
<script type="text/javascript">
	function addLoadEvent(func) {
	  var oldonload = window.onload;
	  if (typeof window.onload != 'function'){
	   window.onload = func;
	  } else
	  {
		window.onload = function() {
		  if (oldonload) {
			oldonload();
		  }
		  func();
		}
	  }
	}
	addLoadEvent(function bbb() 
		{
			if(document.form_basket.ref_no != undefined)
				document.form_basket.ref_no.disabled = true;
			if(document.form_basket.fatura_iptal != undefined && document.form_basket.fatura_iptal.checked == true)
				document.form_basket.fatura_iptal.disabled = true;
		}
	);
	function process_cat_function_86()
	{
		if(document.form_basket.ref_no != undefined)
			document.form_basket.ref_no.disabled = false;
		if(document.form_basket.fatura_iptal != undefined)
			document.form_basket.fatura_iptal.disabled = false;
		return true;
	}
</script>
