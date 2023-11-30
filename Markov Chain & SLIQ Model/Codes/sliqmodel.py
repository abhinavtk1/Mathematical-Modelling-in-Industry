# Python code for SLIQ algorithm
# Here we use the Iris dataset as an example
# The classes are 0: Iris-setosa, 1: Iris-versicolor, 2: Iris-virginica
# The feauters taken are PL: Petal Length, PW: Petal Width
# Model trained using iris_training.csv
# Model tested using iris_test.csv

import csv
# Function to prepare the dataset from the csv file
def data_prep(file_name):
    cols = {'name': ['PL', 'PW'], 'count': 2}     # PL = Petal Length, PW = Petal Width
    data = []
    with open(file_name, 'r', newline='') as csvfile:
        csv_reader = csv.reader(csvfile)
        next(csv_reader)  # Skip the first row
        for row in csv_reader:
            num_row = [float(item) for item in row[2:]]
            num_row[2] = int(num_row[2])
            data.append(num_row)
    return cols, data

# Helper function to create lists of subsets of columns
def create_set(col_set):
    sublists = []
    length = len(col_set)
    for iteration in range(2 ** length):
        cur_set = []
        for digit in range(length):
            if iteration % 2:
                cur_set.append(col_set[digit])
            iteration //= 2
        sublists.append(cur_set)
    return sublists

# Function to sort the column values and class labels
def pre_sort_features(cols, dataset):
    attr_lists = []
    cols['value'] = {}
    
    for colIdx in range(2):
        cols['value'][colIdx] = sorted(list(set([data[colIdx] for data in dataset])))

        curr_attr_list = []
        for dataIndex in range(len(dataset)):
            curr_attr_list.append([dataset[dataIndex][colIdx], dataIndex])
        attr_lists.append(sorted(curr_attr_list))
    return attr_lists, [[data[cols['count']], 1] for data in dataset]

# Function to calculate the Gini index
def gini_calculator(count_0, count_1, count_2):
    total = count_0 + count_1 + count_2
    if total == 0:
        return 0
    
    prob_0 = count_0 / total
    prob_1 = count_1 / total
    prob_2 = count_2 / total
    
    gini = 1 - (prob_0 ** 2 + prob_1 ** 2 + prob_2 ** 2)
    return gini

# Function to check if the data is less than the value
def checker(data, value):
    return data < value

# Function to print the value
def print_value(name, value):
        return str(name) + ' < ' + str(value)
    
# Function to display the decision tree
def print_tree(tree, no, deep):
    if tree[no] in [0, 1, 2]:  # Check if the node is a leaf node with class label
        node = f'{no} {tree[no]}'
        print(node)
        return    
    left = tree[no][2]
    right = tree[no][3]
    
    if tree[left] in [0, 1, 2]:  # Check if the left child is a leaf node with class label
        left = tree[left]
    if tree[right] in [0, 1, 2]:  # Check if the right child is a leaf node with class label
        right = tree[right]
    
    node = f'{no} {tree[no][0]} {tree[no][1]} {left} {right}'
    print(node)
    print_tree(tree, tree[no][2], deep + 1)
    print_tree(tree, tree[no][3], deep + 1)

def is_leaf(classList, node):
    node_class = list(set([x[0] for x in classList if x[1] == node]))
    if len(node_class) != 1:
        return "continue"          # Returns "continue" if it's not a leaf node
    else:
        return node_class[0]    # Returns the class label (0, 1, or 2) if it's a leaf node


def root_split_calculation(cols, attr_lists, class_list, node, used):
    data_num = len(class_list)
    min_gini = 1
    min_index = -1
    min_value = 0
    draw = False
    
    for col_idx in range(cols['count']):
        if col_idx in used:
            continue
        for value in cols['value'][col_idx]:
            count_0 = count_1 = count_2 = 0
            count_total = 0
            
            for item in range(data_num):
                if class_list[attr_lists[col_idx][item][1]][1] != node:
                    continue
                if checker(attr_lists[col_idx][item][0], value):
                    if class_list[attr_lists[col_idx][item][1]][0] == 0:
                        count_0 += 1
                    elif class_list[attr_lists[col_idx][item][1]][0] == 1:
                        count_1 += 1
                    else:
                        count_2 += 1
                count_total += 1
            
            gini_index = gini_calculator(count_0, count_1, count_2)
            if gini_index < min_gini:
                min_gini = gini_index
                min_value = value
                min_index = col_idx

                draw = ((count_0 * count_1 > 0) or (count_0 * count_2 > 0) or (count_1 * count_2 > 0)) and (
                    count_0 + count_1 + count_2 == 0)
                
                if draw:
                    # Resolve draw based on the majority count
                    max_count = max(count_0, count_1, count_2)
                    if max_count == count_0:
                        draw = 0
                    elif max_count == count_1:
                        draw = 1
                    else:
                        draw = 2
    
    return min_index, min_value, draw

def build_tree(cols, col_lists, class_list):
    tree = {}
    tree[1] = 0  # Root node starts with class 0
    queue = [[1]]
    data_num = len(class_list)
    
    while queue:
        t_node = queue.pop(0)
        node = t_node[0]
        used = t_node[1:]
        
        flag = is_leaf(class_list, node)
        if flag != "continue":
            tree[node] = flag
            continue
        
        min_index, min_value, draw = root_split_calculation(cols, col_lists, class_list, node, used)
        
        if min_index == -1:
            continue
        
        if draw is not False:
            tree[node] = draw
            continue
        
        left = len(tree) + 1
        right = left + 1
        
        tree[node] = [tree[node], print_value(cols['name'][min_index], min_value),
                      left, right, min_index, min_value]
        
        tree[left] = 0
        tree[right] = 0
        
        for item in range(data_num):
            if class_list[col_lists[min_index][item][1]][1] != node:
                continue
            if checker(col_lists[min_index][item][0], min_value):
                class_list[col_lists[min_index][item][1]][1] = left
            else:
                class_list[col_lists[min_index][item][1]][1] = right
        
        q_left = [left]
        q_right = [right]
        
        for item in used:
            q_left.append(item)
            q_right.append(item)
        
        if min_index not in used:
            q_left.append(min_index)
            q_right.append(min_index)
        
        queue.append(q_left)
        queue.append(q_right)
    
    return tree

def test_decision_node(tree, node, data):
    if tree[node] in [0, 1, 2]:  # Leaf nodes are class labels
        return tree[node]
    
    attribute_index = tree[node][4]
    attribute_value = tree[node][5]

    if data[attribute_index] < attribute_value:
        return test_decision_node(tree, tree[node][2], data)
    else:
        return test_decision_node(tree, tree[node][3], data)


def test_decision_tree(tree, test_data):
    length = len(test_data)
    if not length:
        return 'Null'
    count = 0
    for data in test_data:
        if test_decision_node(tree, 1, data) == data[-1]:
            count += 1
    return float(count) / length

def train_decision_tree(file_name):
    columns, train_data = data_prep(file_name)
    col_lists, class_list = pre_sort_features(columns, train_data)   
    tree = build_tree(columns, col_lists, class_list)
    print('SLIQ Model:')
    print_tree(tree, 1, 0)
    print('\nModel accuracy for Train data (iris_training.csv): %.4f' % test_decision_tree(tree, train_data))    
    return tree

def decision_tree_testing(file_name, tree):
    _, test_data = data_prep(file_name)
    print('Model accuracy for Test data (iris_test.csv): %.4f' % test_decision_tree(tree, test_data))

if __name__ == '__main__':
        dtree = train_decision_tree('iris_training.csv')
        decision_tree_testing('iris_test.csv', dtree)