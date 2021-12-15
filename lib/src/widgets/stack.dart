class StackDS<T> {
  List<T> _list = [];

  void push(T item) {
    _list.add(item);
  }

  T pop() {
    if (isEmpty()) throw Exception('Stack is Empty');

    return _list.removeLast();
  }

  void clear() {
    _list.clear();
  }

  bool isEmpty() {
    return _list.isEmpty;
  }

  @override
  String toString() {
    return _list.toString();
  }
}
