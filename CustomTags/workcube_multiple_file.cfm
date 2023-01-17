<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.field_name" default="file_1">
<cfparam name="attributes.field_count" default="5">
<cfparam name="attributes.div_width" default="400">
<cfparam name="attributes.div_height" default="70">

<script>
	function MultiSelector( list_target, max ){

	// Where to write the list
	this.list_target = list_target;
	// How many elements?
	this.count = 0;
	// How many elements?
	this.id = 0;
	// Is there a maximum?
	if( max ){
		this.max = max;
	} else {
		this.max = -1;
	};

	/**
	 * Add a new file input element
	 */
	this.addElement = function(element){
	
		// Make sure it's a file input element
		if( element.tagName == 'INPUT' && element.type == 'file' ){

			// Element name -- what number am I?
			element.name = 'file_' + this.id++;
		
			// Add reference to this object
			element.multi_selector = this;
	
			// What to do when a file is selected
			element.onchange = function(){

				// New file input
				var new_element = document.createElement( 'input' );
				new_element.type = 'file';

				// Add new element
				this.parentNode.insertBefore( new_element, this );

				// Apply 'update' to element
				this.multi_selector.addElement( new_element );

				// Update list
				this.multi_selector.addListRow( this );

				// Hide this: we can't use display:none because Safari doesn't like it
				this.style.position = 'absolute';
				this.style.left = '-1000px';

			};
			// If we've reached maximum number, disable input element
			if( this.max != -1 && this.count >= this.max ){
				element.disabled = true;
			};

			// File element counter
			this.count++;
			// Most recent element
			this.current_element = element;
			
		} else {
			// This can only be applied to file input elements!
			alert( 'Error: not a file input element' );
		};

	};

	/**
	 * Add a new row to the list of files
	 */
	this.addListRow = function(element)
	{
		// Delete button
		var new_row_button = document.createElement( 'input' );
		new_row_button.type = 'button';
		new_row_button.value = '-';
		
		// Row div
		var new_row = document.createElement( 'div' );

		
		// References
		new_row.element = element;

		// Delete function
		new_row_button.onclick= function(){

			// Remove element from form
			this.parentNode.element.parentNode.removeChild( this.parentNode.element );

			// Remove this row from the list
			this.parentNode.parentNode.removeChild( this.parentNode );

			// Decrement counter
			this.parentNode.element.multi_selector.count--;

			// Re-enable input element (if it's disabled)
			this.parentNode.element.multi_selector.current_element.disabled = false;

			// Appease Safari
			//    without it Safari wants to reload the browser window
			//    which nixes your already queued uploads
			return false;
		};

		// Set row value

		//alert(list_len(element.value,DIR_SEPARATOR));
		new_row.innerHTML = element.value;
		//new_row.innerHTML = 'Ekli Dosya';
		
		// Add button
		new_row.appendChild(new_row_button);

		// Add it to the list
		this.list_target.appendChild(new_row);
		
	};
};
</script>

<cfoutput>
	<input id="#attributes.field_name#_element" type="file" name="#attributes.field_name#" width="#attributes.div_width#px" height="#attributes.div_height#px">
	<div id="#attributes.field_name#_list" style="overflow:auto;width:#attributes.div_width#px;height:#attributes.div_height#px;border: 696969 1px solid;"></div>
    <input type="hidden" name="form_complete_all"  id="form_complete_all">
<script>
	function defined_objects()//ajax ile çağırılan sayfalarda,sayfa yüklenirken onload olayında fonksiyon çağırıldığı için,ajax ile çağırılmalarda fonksiyon tanımlanmmamış oluyordu,bu sebeble form_complete_all inputu sayfanın sonuna ekleniyor,daha sonra aşağıdaki fonksiyon ile bu nesnenin tanımlı olup olunmadığına bakılıyor,tanımlı olduğu zaman,yani sayfa ajax ise tamami ile yüklendiği zaman,çalışması gereken fonksiyon çalıştırılıyor.
		{
		if (document.getElementById('form_complete_all'))
			{
				var multi_selector = new MultiSelector(document.getElementById('#attributes.field_name#_list'),#attributes.field_count#);
				multi_selector.addElement(document.getElementById('#attributes.field_name#_element'));	
			}
		else
		setTimeout('defined_objects()',20);
		}
	defined_objects();
</script>
</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
