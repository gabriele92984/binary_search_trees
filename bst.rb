class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root_node = Node.new(array[mid])

    root_node.left = build_tree(array[0..mid])
    root_node.right = build_tree(array[mid + 1..-1])

    root_node
  end

  def insert(value, node = @root)
    return Mode.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value.node.right)
    end

    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
        node.right = delete(value, node.right)
    else
      # Node with only one child or no child
      if node.left.nil?
        return node.right
      elsif node.right?
        return node.left
      end

      # Node with two children: get the inorder successor (smallest in the right subtree)
      temp = min_value_node(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end

    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end