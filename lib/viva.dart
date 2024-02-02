import 'dart:async';

void main()async {
  int x = await Sum(1,2);

  Sum(2,3).then((value) => print('........'),);
  print(x);
}

Future<int> Sum(int a, int b) async{
  int c = a+b;

 return c;
}