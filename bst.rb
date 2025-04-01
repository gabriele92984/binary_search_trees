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

  def min_value_node(node)
    current = node
    current = current.left while current&.left
    current
  end

  def find(value, node = @root)
    return nil if node.nil?

    if value == node.data
      node
    elsif value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order(node = @root, &block)
    return [] if node.nil?
    queue = [node]
    values = []

    until queue.empty?
      current = queue.shift

      if block_given?
        yield(current)
      else  
        values << current.data
      end
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end

    values
  end

  def inorder(node = @root, &block)
    return [] if node.nil?
    values = []

    left_values = inorder(node.left, &block)
    if block_given?
      yield(node)
    else 
      values << node.data
    end
    right_values = inorder(node.right, &block)
    
    left_values + values + right_values
  end

  def preorder(node = @root, &block)
    return [] if node.nil?
    values = []

    if block_given?
      yield(node)
    else
      values << node.data
    end
    left_values = preorder(node.left, &block)
    right_values = preorder(node.right, &block)

    values + left_values + right_values
  end

  def postorder(node = @root, &block)
    return [] if node.nil?
    values = []

    left_values = postorder(node.left, &block)
    right_values = postorder(node.right, &block)
    if block_given?
      yield(node)
    else
      values << node.data
    end

    left_values + right_values + values
  end

  def height(node)
    return -1 if node.nil? # Height of a nil node is -1

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  def depth(node, current_node = @root, current_depth = 0)
    return nil if @root.nil? || node.nil?
    return current_depth if node == current_node

    if node.data < current_node.data
      depth(node, current_node.left, current_depth + 1)
    elsif node.data > current_node.data
      depth(node, current_node.right, current_depth + 1)
    else
      # This case should ideally be caught by the 'node == current_node' condition
      current_depth
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    return if @root.nil?
    array = inorder # Get the nodes in inorder traversal (which will be sorted)
    @root = build_tree(array) # Rebuild the tree from the sorted array
  end

  def pretty_print(node = @root, prefix = '', is_left = true)                  
    if node.right
      new_prefix = prefix + (is_left ? '│   ' : '    ')
      pretty_print(node.right, new_prefix, false)
    end

    connector = if is_left
                  '└── '
                else
                  '┌── '
                end
    puts "#{prefix}#{connector}#{node.data}"

    if node.left
      new_prefix = prefix + (is_left ? '    ' : '│   ')
      pretty_print(node.left, new_prefix, true)
    end
  end
end

# Create a binary search tree from an array of random numbers
random_array = Array.new(15) { rand(1..100) }
bst = Tree.new(random_array)
puts "Initial Tree:"
bst.pretty_print

# Confirm that the tree is balanced
puts "Balanced? #{bst.balanced?}"

# Print out all elements in level, pre, post, and in order
puts "\nLevel Order: #{bst.level_order}"
puts "Preorder: #{bst.preorder}"
puts "Postorder: #{bst.postorder}"
puts "Inorder: #{bst.inorder}"

# Unbalance the tree by adding several numbers > 100
bst.insert(150)
bst.insert(160)
bst.insert(170)
puts "\nTree after adding unbalanced nodes:"
bst.pretty_print

# Confirm that the tree is unbalanced
puts "Balanced? #{bst.balanced?}"

# Balance the tree
bst.rebalance
puts "\nBalanced Tree:"
bst.pretty_print

# Confirm that the tree is balanced
puts "Balanced? #{bst.balanced?}"

# Print out all elements in level, pre, post, and in order
puts "\nLevel Order: #{bst.level_order}"
puts "Preorder: #{bst.preorder}"
puts "Postorder: #{bst.postorder}"
puts "Inorder: #{bst.inorder}"