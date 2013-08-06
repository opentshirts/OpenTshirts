/*
 PureMVC AS3 Utility – Undo
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */

package org.puremvc.as3.utilities.undo.model.enum
{
	/**
	 * The possible types of undoable commands:
	 * 1. RecordableCommand - will save the command into the commands history
	 * 2. NonRecordableCommand - will not save the comand into the history
	 * 
	 * When building an IUndoableCommand,  set note.type = one of these options
	 *   
	 * @author dragos
	 */
	public class UndoableCommandTypeEnum
	{
		public static const RECORDABLE_COMMAND:String 		= "RecordableCommand";
		public static const NON_RECORDABLE_COMMAND:String 	= "NonRecordableCommand";
	}

}