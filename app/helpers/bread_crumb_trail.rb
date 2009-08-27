class BreadCrumbTrail
  def initialize
    @crumbs = []
  end
  
  def crumbs
    @crumbs
  end
  
  def push(path)
    @crumbs.push(path)
  end
  
  def match_at(element)
    @crumbs.index(element)
  end

  def trim_after(i)
    # Trim everything away beyond the matching path in the stack. Don't bother if last element
    # on stack - no-op (btw slice! is important here - don't use slice (no !) unless you're
    # writing a different algorithm that requires its different behavior)
    @crumbs.slice!((i + 1)..(@crumbs.size - 1)) if i < (@crumbs.size - 1)
  end
  
  def size
    @crumbs.size
  end
  
  def [](i)
    @crumbs[i]
  end
  
  def to_s
    "#{@crumbs.join(", ")}"
  end
end