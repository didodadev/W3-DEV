/*
 * Copyright (c) 2006-2013, JGraph Ltd
 *
 * Defines the startup sequence of the application.
 */
{

	/**
	 * Constructs a new application (returns an mxEditor instance)
	 */
	function createEditor(config)
	{
		var editor = null;
		
		var hideSplash = function()
		{
			// Fades-out the splash screen
			var splash = document.getElementById('splash');
			
			if (splash != null)
			{
				try
				{
					mxEvent.release(splash);
					mxEffects.fadeOut(splash, 100, true);
				}
				catch (e)
				{
					splash.parentNode.removeChild(splash);
				}
			}
		};
		
		try
		{
			if (!mxClient.isBrowserSupported())
			{
				mxUtils.error('Browser is not supported!', 200, false);
			}
			else
			{
				mxObjectCodec.allowEval = true;
				var node = mxUtils.load(config).getDocumentElement();
				editor = new mxEditor(node);
				mxObjectCodec.allowEval = false;
				
				// Adds active border for panning inside the container
				editor.graph.createPanningManager = function()
				{
					var pm = new mxPanningManager(this);
					pm.border = 30;
					
					return pm;
				};
				
				editor.graph.allowAutoPanning = true;
				editor.graph.timerAutoScroll = true;

				/* make shapes connect points */

				editor.graph.setConnectable(true);

				//graph.connectionHandler.connectImage = new mxImage('images/connector.gif', 16, 16);

				// Disables floating connections (only use with no connect image)
				if (editor.graph.connectionHandler.connectImage == null)
				{
					editor.graph.connectionHandler.isConnectableCell = function(cell)
					{
					   return false;
					};
					mxEdgeHandler.prototype.isConnectableCell = function(cell)
					{
						return editor.graph.connectionHandler.isConnectableCell(cell);
					};
				}
				
				editor.graph.getAllConnectionConstraints = function(terminal)
				{
					if (terminal != null && this.model.isVertex(terminal.cell))
					{
						return [new mxConnectionConstraint(new mxPoint(0, 0), true),
					    	new mxConnectionConstraint(new mxPoint(0.5, 0), true),
					    	new mxConnectionConstraint(new mxPoint(1, 0), true),
					    	new mxConnectionConstraint(new mxPoint(0, 0.5), true),
							new mxConnectionConstraint(new mxPoint(1, 0.5), true),
							new mxConnectionConstraint(new mxPoint(0, 1), true),
							new mxConnectionConstraint(new mxPoint(0.5, 1), true),
							new mxConnectionConstraint(new mxPoint(1, 1), true)];
					}

					return null;
				};
				
				
				// Connect preview
				editor.graph.connectionHandler.createEdgeState = function(me)
				{
					var edge = editor.graph.createEdge(null, null, null, null, null, 'edgeStyle=orthogonalEdgeStyle');
					
					return new mxCellState(this.graph.view, edge, this.graph.getCellStyle(edge));
				};


				// Updates the window title after opening new files
				var title = document.title;
				var funct = function(sender)
				{
					document.title = title + ' - ' + sender.getTitle();
				};
				
				editor.addListener(mxEvent.OPEN, funct);
				
				// Prints the current root in the window title if the
				// current root of the graph changes (drilling).
				editor.addListener(mxEvent.ROOT, funct);
				funct(editor);
				
				// Displays version in statusbar
				editor.setStatus('mxGraph '+mxClient.VERSION);

				// Shows the application
				hideSplash();

				window.currenteditor = editor;
			}
		}
		catch (e)
		{
			hideSplash();

			// Shows an error message if the editor cannot start
			mxUtils.alert('Cannot start application: ' + e.message);
			throw e; // for debugging
		}

		return editor;
	}

}
