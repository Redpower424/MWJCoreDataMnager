# MWJCoreDataMnager
简单的CoreData封装
在Xcode8.0中使用CoreData注意点：
1.创建NSManagedObject Subclass对象，先选中后缀为.xcdatamodeld的模型文件，在Editor下拉栏中点击Create NSManagedObject Subclass，会生成四个文件
2.创建完NSManagedObject对象，若此时直接运行会报错ld: 2 duplicate symbols for architecture x86_64，是有mo文件重复了，系统自动生成的原因。解决方法：方法1.打开在model file的inspector，选择Tools Version为 Xcode 7.3；方法2.或者你可以根据不同的entity去分别选择启用还是关闭自动生成机制；选择model file中特定的entity，打开其Data Model Inspector窗口，将其中的Codegen选项设置为Manual／None。
