package language
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	
	public class ResourceLanguage
	{
		public function ResourceLanguage()
		{
		}
		
		public static function setResources(resourceManager:IResourceManager):void
		{
			var myResources:ResourceBundle=new ResourceBundle("en","languageResources");
			myResources.content['CLIPART_PROPERTIES']="Clipart Properties";
			myResources.content['COLORS']="Colors";
			myResources.content['COLOR']="Color";
			myResources.content['PRODUCTS']="Products";
			myResources.content['CLIPART']="Clipart";
			myResources.content['ADD_CLIPART']="Add Clipart";
			myResources.content['ADD_TEXT']="Add Text";
			myResources.content['SELECT_PRODUCT']="Select Product";
			myResources.content['SEARCH']="Search";
			myResources.content['VIEWS']="Views";
			myResources.content['FULL_COLOR']="Full Color";
			myResources.content['DUO_COLOR']="Two Colors";
			myResources.content['ONE_COLOR']="One Color";
			myResources.content['INVERT']="Invert";
			myResources.content['MOVE_TO_TOP']="To front";
			myResources.content['MOVE_TO_BOTTOM']="To back";
			myResources.content['MOVE_FORWARD']="Forward one";
			myResources.content['MOVE_BACKWARD']="Backward one";
			myResources.content['WIDTH']="Width";
			myResources.content['HEIGHT']="Height";
			myResources.content['ROTATION']="Rotation";
			myResources.content['X']="X";
			myResources.content['Y']="Y";
			myResources.content['LOCKED']="Locked";
			myResources.content['RESET_PROPORTIONS']="Reset Proportions";
			myResources.content['TEXT']="Text Editor";
			myResources.content['ENTER_TEXT']="Enter Text Here";
			myResources.content['FONT']="Select a Font";
			myResources.content['SPACING']="Adjust Text Spacing";
			myResources.content['TEXT_COLOR']="Edit Text Color";
			myResources.content['ALIGN_TO_BOTTOM']="Align to bottom";
			myResources.content['ALIGN_TO_TOP']="Align to top";
			myResources.content['ALIGN_TO_LEFT']="Align to left";
			myResources.content['ALIGN_TO_RIGHT']="Align to right";
			myResources.content['CENTER_VERTICAL']="Center vertically (E)";
			myResources.content['CENTER_HORIZONTAL']="Center horizontally (C)";
			myResources.content['ARRANGE']="Arrange";
			myResources.content['ALIGN']="Align";
			myResources.content['ZOOM_IN']="Zoom in";
			myResources.content['ZOOM_TO_AREA']="Zoom to print area";
			myResources.content['ZOOM_OUT']="Zoom out";
			myResources.content['FILTERS']="Text Outlines and Drop Shadow";
			myResources.content['FILTER_COLOR']="Outline/Shadow Color";
			myResources.content['SELECT_FILTER']="Select filter";
			myResources.content['THICKNESS']="Thickness";
			myResources.content['DISTANCE']="Distance";
			myResources.content['ANGLE']="Angle";
			myResources.content['OUTLINE']="Outline";
			myResources.content['SHADOW']="Drop Shadow";
			myResources.content['VISIBLE']="Visible";
			myResources.content['TEXT_EFFECT']="Text Effect";
			myResources.content['ADJUST_EFFECTS']="Adjust Effect";
			myResources.content['SELECT_FONT']="Select Font";
			myResources.content['SELECT_SHAPE']="Select Shape";
			myResources.content['COLORS_USED']="Colors used";
			myResources.content['SELECT_LAYERS_TO_TINT']="Select the layers you want to paint";
			myResources.content['SAVE_DESIGN']="Save design";
			myResources.content['SELECT_PRODUCT_FIRST']="Select a product first";
			myResources.content['EXPORT_IMAGE']="Save Snapshot";
			myResources.content['PRODUCT_COLORS']="Available product colors";
			myResources.content['OBJECT_PROPERTIES']="Object Properties";
			myResources.content['CLIPART_PROPERTIES']="Clip Art Color Management";
			myResources.content['COLOR_PALETTE']="Color Palette";
			myResources.content['SELECT_ALL']="Select All (Ctrl + A)";
			myResources.content['FIT_TO_AREA']="Fit to area (M)";
			myResources.content['FLIP_H']="Flip Horizontal (H)";
			myResources.content['FLIP_V']="Flip Vertical (V)";
			resourceManager.addResourceBundle(myResources);
			
			myResources=new ResourceBundle("es","languageResources");
			myResources.content['CLIPART_PROPERTIES']="Propiedades del Clipart";
			myResources.content['COLORS']="Colores";
			myResources.content['COLOR']="Color";
			myResources.content['PRODUCTS']="Productos";
			myResources.content['CLIPART']="Arte";
			myResources.content['ADD_CLIPART']="Agregar Arte";
			myResources.content['ADD_TEXT']="Agregar Texto";
			myResources.content['SELECT_PRODUCT']="Seleccionar Producto";
			myResources.content['SEARCH']="Buscar";
			myResources.content['VIEWS']="Vistas";
			myResources.content['FULL_COLOR']="Full Color";
			myResources.content['DUO_COLOR']="Dos Colores";
			myResources.content['ONE_COLOR']="Un Color";
			myResources.content['INVERT']="Invertir";
			myResources.content['TEXT']="Texto";
			myResources.content['ENTER_TEXT']="Ingrese el texto";
			myResources.content['MOVE_TO_TOP']="Traer al frente";
			myResources.content['MOVE_TO_BOTTOM']="Enviar al fondo";
			myResources.content['MOVE_FORWARD']="Hacia adelante";
			myResources.content['MOVE_BACKWARD']="Hacia atras";
			myResources.content['WIDTH']="Ancho";
			myResources.content['HEIGHT']="Alto";
			myResources.content['ROTATION']="Rotación";
			myResources.content['X']="X";
			myResources.content['Y']="Y";
			myResources.content['LOCKED']="Bloqueado";
			myResources.content['RESET_PROPORTIONS']="Resetear Proporción";
			myResources.content['FONT']="Fuente";
			myResources.content['SPACING']="Espaciado";
			myResources.content['TEXT_COLOR']="Edit Text Color";
			myResources.content['ALIGN_TO_BOTTOM']="Alinear al piso";
			myResources.content['ALIGN_TO_TOP']="Alinear al techo";
			myResources.content['ALIGN_TO_LEFT']="Alinear a la izquierda";
			myResources.content['ALIGN_TO_RIGHT']="Alinear a la derecha";
			myResources.content['CENTER_VERTICAL']="Centrar verticalmente (E)";
			myResources.content['CENTER_HORIZONTAL']="Centrar horizontalmente (C)";
			myResources.content['ARRANGE']="Organizar";
			myResources.content['ALIGN']="Alinear";
			myResources.content['ZOOM_IN']="Acercar";
			myResources.content['ZOOM_TO_AREA']="Enfocar area imprimible";
			myResources.content['ZOOM_OUT']="Alejar";
			myResources.content['FILTERS']="Filtros";
			myResources.content['FILTER_COLOR']="Outline/Shadow Color";
			myResources.content['SELECT_FILTER']="Seleccione el filtro";
			myResources.content['THICKNESS']="Grosor";
			myResources.content['DISTANCE']="Distancia";
			myResources.content['ANGLE']="Ángulo";
			myResources.content['OUTLINE']="Filete";
			myResources.content['SHADOW']="Sombra";
			myResources.content['VISIBLE']="Visible";
			myResources.content['TEXT_EFFECT']="Efecto";
			myResources.content['ADJUST_EFFECTS']="Ajustar efecto";
			myResources.content['SELECT_FONT']="Seleccione una fuente";
			myResources.content['SELECT_SHAPE']="Seleccione una forma";
			myResources.content['COLORS_USED']="Colores usados";
			myResources.content['SELECT_LAYERS_TO_TINT']="Seleccione las capas que quiere pintar";
			myResources.content['SAVE_DESIGN']="Guardar diseño";
			myResources.content['SELECT_PRODUCT_FIRST']="Debe seleccionar un producto primero";
			myResources.content['EXPORT_IMAGE']="Guardar foto";
			myResources.content['PRODUCT_COLORS']="Colores disponibles";
			myResources.content['OBJECT_PROPERTIES']="Propiedades de objeto";
			myResources.content['CLIPART_PROPERTIES']="Clip Art Color Management";
			myResources.content['COLOR_PALETTE']="Paleta de Colores";
			myResources.content['SELECT_ALL']="Select All (Ctrl + A)";
			myResources.content['FIT_TO_AREA']="Fit to area (M)";
			myResources.content['FLIP_H']="Flip Horizontal (H)";
			myResources.content['FLIP_V']="Flip Vertical (V)";
			resourceManager.addResourceBundle(myResources);
					
			resourceManager.update();
		}
	}
}