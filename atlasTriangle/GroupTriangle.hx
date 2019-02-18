package atlasTriangle;
import openfl.geom.Point;

/**
 * ...
 * @author loudo (port from openfl)
 */
class GroupTriangle extends SpriteTriangle
{

	var _children:Array<SpriteTriangle>;
	@:isVar public var length(default, null):Int;
	
	public function new(?center:Point) 
	{
		super(null, center);
		_children = [];
		length = 0;
		hasChildren = true;
	}
	
	public function addChild(child:SpriteTriangle):SpriteTriangle
	{
		if (child.parent == this)
		{
			_children.remove(child);
			length--;
		}
		
		_children.push(child);
		child.parent = this;
		length++;
		
		__setRenderDirty();
		
		return child;
	}
	
	public function addChildAt(child:SpriteTriangle, index:Int):SpriteTriangle
	{
		if (child.parent == this)
		{
			_children.remove(child);
			length--;
		}
		
		_children.insert(index, child);
		child.parent = this;
		length++;
		
		__setRenderDirty();
		
		return child;
	}
	
	public function contains(child:SpriteTriangle):Bool
	{
		return (_children.indexOf(child) > -1);
	}
	
	public function getChildAt(index:Int):SpriteTriangle
	{
		if (index >= 0 && index < _children.length)
		{
			return _children[index];
		}

		return null;
	}

	public function getChildIndex(child:SpriteTriangle):Int
	{
		for (i in 0..._children.length)
		{
			if (_children[i] == child) return i;
		}

		return -1;
	}

	public function removeChild(child:SpriteTriangle):SpriteTriangle
	{
		if (child != null && child.parent == this)
		{
			child.parent = null;
			_children.remove(child);
			length--;
			
			__setRenderDirty();
		}

		return child;
	}

	public function removeChildAt(index:Int):SpriteTriangle
	{
		if (index >= 0 && index < _children.length)
		{
			return removeChild(_children[index]);
		}

		return null;
	}

	public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		if (beginIndex < 0) beginIndex = 0;
		if (endIndex > _children.length - 1) endIndex = _children.length - 1;

		var removed = _children.splice(beginIndex, endIndex - beginIndex + 1);
		for (child in removed)
		{
			child.parent = null;
		}
		
		length = _children.length;

		__setRenderDirty();
	}

	public function setChildIndex(child:SpriteTriangle, index:Int):Void
	{
		if (index >= 0 && index <= _children.length && child.parent == this)
		{
			_children.remove(child);
			_children.insert(index, child);
			__setRenderDirty();
		}
	}

	public function swapChildren(child1:SpriteTriangle, child2:SpriteTriangle):Void
	{
		if (child1.parent == this && child2.parent == this)
		{
			var index1 = _children.indexOf(child1);
			var index2 = _children.indexOf(child2);

			_children[index1] = child2;
			_children[index2] = child1;

			__setRenderDirty();
		}
	}

	public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		var swap = _children[index1];
		_children[index1] = _children[index2];
		_children[index2] = swap;
		swap = null;

		__setRenderDirty();
	}
	
}