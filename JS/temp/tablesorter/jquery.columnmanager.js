
(function($) 
{
	var defaults = {
		listTargetID : null,
		onClass : '',
		offClass : '',
		hideInList: [],
		colsHidden: [],
		saveState: false,
		onToggle: null,
		show: function(cell){
			showCell(cell);
		},
		hide: function(cell){
			hideCell(cell);
		}
	};
	
	var idCount = 0;
	var cookieName = 'columnManagerC';

	/**
	 * Saves the current state for the table in a cookie.
	 * @param {element} table	The table for which to save the current state.
	 */
	var saveCurrentValue = function(table)
	{
		var val = '', i = 0, colsVisible = table.cMColsVisible;
		if ( table.cMSaveState && table.id && colsVisible && $.cookie )
		{
			for ( ; i < colsVisible.length; i++ )
			{
				val += ( colsVisible[i] == false ) ? 0 : 1;
			}
			$.cookie(cookieName + table.id, val, {expires: 9999});
		}
	};
	
	/**
	 * Hides a cell.
	 * It rewrites itself after the browsercheck!
	 * @param {element} cell	The cell to hide.
	 */
	var hideCell = function(cell)
	{
		if ( jQuery.browser.msie )
		{
			(hideCell = function(c)
			{
				c.style.setAttribute('display', 'none');
			})(cell);
		}
		else
		{
			(hideCell = function(c)
			{
				c.style.display = 'none';
			})(cell);
		}
	};

	/**
	 * Makes a cell visible again.
	 * It rewrites itself after the browsercheck!
	 * @param {element} cell	The cell to show.
	 */
	var showCell = function(cell)
	{
		if ( jQuery.browser.msie )
		{
			(showCell = function(c)
			{
				c.style.setAttribute('display', 'table-cell');
			})(cell);
		}
		else
		{
			(showCell = function(c)
			{
				c.style.display = 'table-cell';
			})(cell);
		}
	};

	/**
	 * Returns the visible state of a cell.
	 * It rewrites itself after the browsercheck!
	 * @param {element} cell	The cell to test.
	 */
	var cellVisible = function(cell)
	{
		if ( jQuery.browser.msie )
		{
			return (cellVisible = function(c)
			{
				return c.style.getAttribute('display') != 'none';
			})(cell);
		}
		else
		{
			return (cellVisible = function(c)
			{
				return c.style.display != 'none';
			})(cell);
		}
	};

	/**
	 * Returns the cell element which has the passed column index value.
	 * @param {element} table	The table element.
	 * @param {array} cells		The cells to loop through.
	 * @param {integer} col	The column index to look for.
	 */
	var getCell = function(table, cells, col)
	{
		for ( var i = 0; i < cells.length; i++ )
		{
			if ( cells[i].realIndex === undefined ) //the test is here, because rows/cells could get added after the first run
			{
				fixCellIndexes(table);
			}
			if ( cells[i].realIndex == col )
			{
				return cells[i];
			}
		}
		return null;
	};

	var fixCellIndexes = function(table) 
	{
		var rows = table.rows;
		var len = rows.length;
		var matrix = [];
		for ( var i = 0; i < len; i++ )
		{
			var cells = rows[i].cells;
			var clen = cells.length;
			for ( var j = 0; j < clen; j++ )
			{
				var c = cells[j];
				var rowSpan = c.rowSpan || 1;
				var colSpan = c.colSpan || 1;
				var firstAvailCol = -1;
				if ( !matrix[i] )
				{ 
					matrix[i] = []; 
				}
				var m = matrix[i];
				// Find first available column in the first row
				while ( m[++firstAvailCol] ) {}
				c.realIndex = firstAvailCol;
				for ( var k = i; k < i + rowSpan; k++ )
				{
					if ( !matrix[k] )
					{ 
						matrix[k] = []; 
					}
					var matrixrow = matrix[k];
					for ( var l = firstAvailCol; l < firstAvailCol + colSpan; l++ )
					{
						matrixrow[l] = 1;
					}
				}
			}
		}
	};

	$.fn.columnManager = function(options)
	{
		var settings = $.extend({}, defaults, options);

		/**
		 * Creates the column header list.
		 * @param {element} table	The table element for which to create the list.
		 */
		var createColumnHeaderList = function(table)
		{
			if ( !settings.listTargetID )
			{
				return;
			}
			var $target = $('#' + settings.listTargetID);
			if ( !$target.length )
			{
				return;
			}
			//select headrow - when there is no thead-element, use the first row in the table
			var headRow = null;
			if ( table.tHead && table.tHead.length )
			{
				headRow = table.tHead.rows[0];
			}
			else if ( table.rows.length )
			{
				headRow = table.rows[0];
			}
			else
			{
				return; //no header - nothing to do
			}
			var cells = headRow.cells;
			if ( !cells.length )
			{
				return; //no header - nothing to do
			}
			//create list in target element
			var $list = null;
			if ( $target.get(0).nodeName.toUpperCase() == 'UL' )
			{
				$list = $target;
			}
			else
			{
				$list = $('<ul></ul>');
				$target.append($list);
			}
			var colsVisible = table.cMColsVisible;
			//create list elements from headers
			for ( var i = 0; i < cells.length; i++ )
			{
				if ( $.inArray(i + 1, settings.hideInList) >= 0 )
				{
					continue;
				}
				colsVisible[i] = ( colsVisible[i] !== undefined ) ? colsVisible[i] : true;
				var text = $(cells[i]).text(), 
					addClass;
				if ( !text.length )
				{
					text = $(cells[i]).html();
					if ( !text.length ) //still nothing?
					{
						text = 'undefined';
					}
				}
				if ( colsVisible[i] && settings.onClass )
				{
					addClass = settings.onClass;
				}
				else if ( !colsVisible[i] && settings.offClass )
				{
					addClass = settings.offClass;
				}
				var $li = $('<li class="' + addClass + '">' + text + '</li>').click(toggleClick);
				$li[0].cmData = {id: table.id, col: i};
				$list.append($li);
			}
			table.cMColsVisible = colsVisible;
		};

		/**
		 * called when an item in the column header list is clicked
		 */
		var toggleClick = function()
		{

			//get table id and column name
			var data = this.cmData;
			if ( data && data.id && data.col >= 0 )
			{
				var colNum = data.col, 
					$table = $('#' + data.id);
				if ( $table.length )
				{
					$table.toggleColumns([colNum + 1], settings);
					//set the appropriate classes to the column header list
					var colsVisible = $table.get(0).cMColsVisible;
					if ( settings.onToggle )
					{
						settings.onToggle.apply($table.get(0), [colNum + 1, colsVisible[colNum]]);
					}
				}
			}
		};

		/**
		 * Reads the saved state from the cookie.
		 * @param {string} tableID	The ID attribute from the table.
		 */
		var getSavedValue = function(tableID)
		{
			var val = $.cookie(cookieName + tableID);
			if ( val )
			{
				var ar = val.split('');
				for ( var i = 0; i < ar.length; i++ )
				{
					ar[i] &= 1;
				}
				return ar;
			}
			return false;
		};

        return this.each(function()
        {
			this.id = this.id || 'jQcM0O' + idCount++; //we need an id for the column header list stuff
			var i, 
				colsHide = [], 
				colsVisible = [];
			//fix cellIndex values
			fixCellIndexes(this);
			//some columns hidden by default?
			if ( settings.colsHidden.length )
			{
				for ( i = 0; i < settings.colsHidden.length; i++ )
				{
					colsVisible[settings.colsHidden[i] - 1] = true;
					colsHide[settings.colsHidden[i] - 1] = true;
				}
			}
			//get saved state - and overwrite defaults
			if ( settings.saveState )
			{
				var colsSaved = getSavedValue(this.id);
				if ( colsSaved && colsSaved.length )
				{
					for ( i = 0; i < colsSaved.length; i++ )
					{
						colsVisible[i] = true;
						colsHide[i] = !colsSaved[i];
					}
				}
				this.cMSaveState = true;
			}
			//assign initial colsVisible var to the table (needed for toggling and saving the state)
			this.cMColsVisible = colsVisible;
			//something to hide already?
			if ( colsHide.length )
			{
				var a = [];
				for ( i = 0; i < colsHide.length; i++ )
				{
					if ( colsHide[i] )
					{
						a[a.length] = i + 1;
					}
				}
				if ( a.length )
				{
					$(this).toggleColumns(a);
				}
			}
			//create column header list
			createColumnHeaderList(this);
        }); 
	};
	$.fn.toggleColumns = function(columns, cmo)
	{
        return this.each(function() 
        {
			var i, toggle, di, 
				rows = this.rows, 
				colsVisible = this.cMColsVisible;

			if ( !columns )
				return;

			if ( columns.constructor == Number )
				columns = [columns];

			if ( !colsVisible )
				colsVisible = this.cMColsVisible = [];

			//go through all rows in the table and hide the cells
			for ( i = 0; i < rows.length; i++ )
			{
				var cells = rows[i].cells;
				for ( var k = 0; k < columns.length; k++ )
				{
					var col = columns[k] - 1;
					if ( col >= 0 )
					{
						//find the cell with the correct index
						var c = getCell(this, cells, col);
						//cell not found - maybe a previous one has a colspan? - search it!
						if ( !c )
						{
							var cco = col;
							while ( cco > 0 && !(c = getCell(this, cells, --cco)) ) {} //find the previous cell
							if ( !c )
							{
								continue;
							}
						}
						//set toggle direction
						if ( colsVisible[col] == undefined )//not initialized yet
						{
							colsVisible[col] = true;
						}
						if ( colsVisible[col] )
						{
							toggle = cmo && cmo.hide ? cmo.hide : hideCell;
							di = -1;
						}
						else
						{
							toggle = cmo && cmo.show ? cmo.show : showCell;
							di = 1;
						}
						if ( !c.chSpan )
						{
							c.chSpan = 0;
						}
						//the cell has a colspan - so dont show/hide - just change the colspan
						if ( c.colSpan > 1 || (di == 1 && c.chSpan && cellVisible(c)) )
						{
							//is the colspan even reaching this cell? if not we have a rowspan -> nothing to do
							if ( c.realIndex + c.colSpan + c.chSpan - 1 < col )
							{
								continue;
							}
							c.colSpan += di;
							c.chSpan += di * -1;
						}
						else if ( c.realIndex + c.chSpan < col )//a previous cell was found, but doesn't affect this one (rowspan)
						{
							continue;
						}
						else //toggle cell
						{
							toggle(c);
						}
					}
				}
			}
			//set the colsVisible var
			for ( i = 0; i < columns.length; i++ )
			{
				this.cMColsVisible[columns[i] - 1] = !colsVisible[columns[i] - 1];
				//set the appropriate classes to the column header list, if the options have been passed
				if ( cmo && cmo.listTargetID && ( cmo.onClass || cmo.offClass ) )
				{
					var onC = cmo.onClass, offC = cmo.offClass, $li;
					if ( colsVisible[columns[i] - 1] )
					{
						onC = offC;
						offC = cmo.onClass;
					}
					$li = $("#" + cmo.listTargetID + " li").filter(function(){return this.cmData && this.cmData.col == columns[i] - 1;});
					if ( onC )
					{
						$li.removeClass(onC);
					}
					if ( offC )
					{
						$li.addClass(offC);
					}
				}
			}
			saveCurrentValue(this);
		});
	};
	$.fn.showColumns = function(columns, cmo)
	{
        return this.each(function() 
        {
			var i,
				cols = [],
				cV = this.cMColsVisible;
			if ( cV )
			{
				if ( columns && columns.constructor == Number ) 
					columns = [columns];

				for ( i = 0; i < cV.length; i++ )
				{
					//if there were no columns passed, show all - or else show only the columns the user wants to see
					if ( !cV[i] && (!columns || $.inArray(i + 1, columns) > -1) )
						cols.push(i + 1);
				}
				
				$(this).toggleColumns(cols, cmo);
			}
		});
	};

	$.fn.hideColumns = function(columns, cmo)
	{
        return this.each(function() 
        {
			var i,
				cols = columns,
				cV = this.cMColsVisible;
			if ( cV )
			{
				if ( columns.constructor == Number ) 
					columns = [columns];
				cols = [];

				for ( i = 0; i < columns.length; i++ )
				{
					if ( cV[columns[i] - 1] || cV[columns[i] - 1] == undefined )
						cols.push(columns[i]);
				}
				
			}
			$(this).toggleColumns(cols, cmo);
		});
	};
})(jQuery);
