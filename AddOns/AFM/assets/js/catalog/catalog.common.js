$(document).ready(function() {
    
	///////////////////////
	// Catalog Frontpage //
	///////////////////////
	
	// Make selection button group 
	if ($('#make-sel-btngroup').length) {
		$('#make-sel-btngroup .btn-make').click(function(){
			$('#make-sel-btngroup').addClass('has-active');
		});
	}
	
	// VIN example
	if ($('#vin-example').length) {
		$('#vin-example').click(function(ev){
			ev.preventDefault();
			$('#vin').val( $(ev.target).text() );
		});
	}
	
	
	//////////////////////////////////
	// Main Groups / Subgroups Page //
	//////////////////////////////////
	
	// Sidemenu
	if ($('#sidemenu').length) {
		$('#sidemenu > li > a').click(function(ev){
			ev.preventDefault();
			$(ev.target).closest('li').toggleClass('active');
			// (AJAX call to fetch subgroup list here)
			//	Note: use $(ev.target).data('mg') to get mg_code of the group to expand

		});
	}
			
	
});
