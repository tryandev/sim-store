package com.game.global 
{
	import com.game.animation.Avatar;
	import com.game.containers.World;
	import com.game.ui.button.uiButtonSprite;
	import com.game.ui.Cursor;
	import com.game.ui.panels.uiActionGauge;
	import com.game.ui.panels.uiPanelControls;
	import com.game.ui.panels.uiPanelStats;
	/**
	 * ...
	 * @author ...
	 */
	public class GlobalObjects {
		
		public static var world:World;
		public static var cursor:Cursor;
		public static var uiStats:uiPanelStats;
		public static var uiControls:uiPanelControls;
		public static var actionGauge:uiActionGauge;
		public static var currentAvatar:Avatar;
	}
}