/*
 PureMVC AS3 Utility – Undo
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */

package org.puremvc.as3.utilities.undo.model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.undo.interfaces.IUndoableCommand;

	/**
	 * The model that keeps track of the commands.
	 * It provides methods to get the next or the previous command from the history.
	 * <p>
	 * In order to record a command into the history, you must set the type of its notification
	 * to <code>UndoableCommandTypeEnum.RECORDABLE_COMMAND</code>
	 *  </p>
	 * 
	 * @see org.puremvc.as3.utilities.model.enum.UndoableCommandTypeEnum
	 * 
	 * @author dragos
	 */
	public class CommandsHistoryProxy extends Proxy implements IProxy
	{
		/**
		* The name of the proxy.
		*/
		public static const NAME:String = "CommandsHistoryProxy";
		
		/**
		* The name of the notification that informs mediator that UNDO button can be enabled
		*/
		public static const UNDO_ENABLED:String = "undoEnabled";
		/**
		* Notification name that informs mediators that UNDO button can be disabled, 
		 * since the undo stack is empty
		*/
		public static const UNDO_DISABLED:String = "undoDisabled";
		
		/**
		* Notification name that should inform mediator that REDO button can be enabled
		*/
		public static const REDO_ENABLED:String = "redoEnabled";
		/**
		* Notification name to inform mediator that the REDO button should be disabled
		 * since it doesn't have any redo actions in the stack.
		*/
		public static const REDO_DISABLED:String = "redoDisabled";
		
		public static const COMMAND_HISTORY_UPDATED:String = "commandHistoryUpdated";
		
		public function CommandsHistoryProxy( data:Object = null):void
		{
			trace("CommandHistoryProxy [] ");
			super( NAME, data );
		}
		
		private var undoStack:Array = new Array();
		private var redoStack:Array = new Array();
		
		/**
		 * Returns the UNDO command.
		 * <p>
		 * Returns the latest command within the undo commands stack
		 * </p>
		 * @return The undoable command of type <code>IUndoableCommand</code>
		 * 
		 * @see org.puremvc.as3.utilities.interfaces.IUndoableCommand
		 */
		public function getPrevious():IUndoableCommand
		{
			if ( undoStack.length > 0 )
			{
				var cmd:IUndoableCommand = undoStack.pop() as IUndoableCommand;
				redoStack.push(cmd);
				
				sendNotification( REDO_ENABLED );
				if ( undoStack.length == 0 )
					sendNotification( UNDO_DISABLED );
					
				return cmd;
			}
			else
				return null;
		}
		
		/**
		 * Indicates if there is an undo command into the history
		 * @return Return a Boolean value indication if there is an undo command into the history 
		 * 
		 */
		public function get canUndo():Boolean
		{
			return undoStack.length > 0;
		}

		
		/**
		 * Returns the REDO command 
		 * @return The instance of the command
		 */
		public function getNext():IUndoableCommand
		{
			if ( redoStack.length > 0 )
			{
				var cmd:IUndoableCommand = redoStack.pop() as IUndoableCommand;
				undoStack.push(cmd);
				
				sendNotification( UNDO_ENABLED );
				if ( redoStack.length == 0 )
					sendNotification( REDO_DISABLED );
					
				return cmd;
			}
			else
				return null;
		}
		
		/**
		 * Indicates if there is a redo command in the history
		 * @return True if you can redo, false otherwise 
		 * 
		 */
		public function get canRedo():Boolean
		{
			return redoStack.length > 0;
		}

		
		/**
		 * Saves a command into the history.
		 * <p>
		 * UndoableCommandBase calls this method to save its instance into the history, if the type of the notification is
		 * <code>UndoableCommandTypeEnum.RECORDABLE_COMMAND</code>
		 * </p>
		 * 
		 * @param cmd The instance of the command of type <code>IUndoableCommand</code>
		 * 
		 * @see org.puremvc.as3.utilities.interfaces.IUndoableCommand
		 * @see org.puremvc.as3.utilities.model.enum.UndoableCommandTypeEnum
		 */
		public function putCommand( cmd:IUndoableCommand ):void
		{
			redoStack = new Array();
			undoStack.push( cmd );
			//send notification to inform listeners that REDO is now disabled
			// usually you can use this to disable the REDO button
			sendNotification( REDO_DISABLED );
			
			// send notification to inform listeners that it is at least one command in the UNDO stack
			//usually you listen to this notification to enable de UNDO button
			sendNotification( UNDO_ENABLED );
			
			//send notification that a new command has been added to history
			sendNotification(COMMAND_HISTORY_UPDATED, cmd ); 
		}
		
		

		
	}
}