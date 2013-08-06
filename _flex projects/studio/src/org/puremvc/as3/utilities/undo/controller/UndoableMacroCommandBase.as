/*
 PureMVC AS3 Utility – Undo
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
 package org.puremvc.as3.utilities.undo.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.utilities.undo.interfaces.IUndoableCommand;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	

	/**
	 * UndoableMacroCommandBase gives you the posibility to create
	 * a chain of simple commands instead of a single command.
	 * @author dragos
	 * 
	 */
	public class UndoableMacroCommandBase extends UndoableCommandBase implements INotifier, ICommand, IUndoableCommand
	{
		private var subCommands:Array;

		public function UndoableMacroCommandBase():void
		{
			subCommands = new Array();
			initializeMacroCommand();
		}
		
		/**
		 * Method to be overriden in the superclass 
		 */
		protected function initializeMacroCommand():void
		{
			trace("WARNING : " + this + " does not have 'initializeMacroCommand' implemented");
		}
		
		/**
		 * Adds a subcommand to the chain of the commands 
		 * @param commandClassRef The command class
		 */
		protected function addSubCommand( commandClassRef:Class ): void
		{
			subCommands.push(commandClassRef);
		}
		
		override public function execute(note:INotification ) : void
		{
			//trace("execute : " + note.getType(), this );
			
			setNote( note );
			
			executeCommand();
			
			if ( note.getType() == UndoableCommandTypeEnum.RECORDABLE_COMMAND )
			{
				var historyProxy:CommandsHistoryProxy = facade.retrieveProxy( CommandsHistoryProxy.NAME ) as CommandsHistoryProxy;
				historyProxy.putCommand( this );
			}
		}

		override public function executeCommand():void
		{
			//throw new Error("The undoable MACRO command does not have 'executeCommand' method implemented.");
			
			// don't record the sub commands
			var noteType:String = getNote().getType();
			
			// DO NOT RECORD THE SUBCOMMANDS INTO THE HISTORY
			getNote().setType( UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND );
			
			for ( var i:int = 0; i< subCommands.length; i++)	
			{
				var commandClassRef : Class = subCommands[i];
				var commandInstance : ICommand = new commandClassRef();
				commandInstance.execute( getNote() );
			} 
			
			// SET BACK THE ORIGINAL TYPE OF THE NOTE
			getNote().setType( noteType );
		}
		
	}
}