import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3,
  required Function function,
  required String text,
}) {
  return Container(
    width: width,
    height: 48,
    child: MaterialButton(
      onPressed: function as void Function()?,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: background,
    ),
  );
}

Widget defaultFormField({
  bool isPassword = false,
  bool isClickable = true,
  bool noKeyboard = false,
  IconData? suffix,
  Function? onChange,
  Function? onSubmit,
  Function? onTap,
  Function? suffixPressed,
  required Function validate,
  required String label,
  required IconData prefix,
  required TextInputType type,
  required TextEditingController controller,
}) {
  return TextFormField(
    readOnly: noKeyboard,
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit as void Function(String)?,
    onChanged: onChange as void Function(String)?,
    onTap: onTap as void Function()?,
    enabled: isClickable,
    validator: (s) {
      return validate(s);
    },
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: suffixPressed!(),
              icon: Icon(suffix),
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: iColor,
            foregroundColor: sColor,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: fColor,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: fColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 18),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(
                status: 'archive',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive,
              color: fColor,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deletData(id: model['id']);
    },
  );
}

Widget tasksBuilder({
  required List<Map> tasks,
}) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: fColor,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fColor,
            ),
          ),
        ],
      ),
    ),
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 18),
        child: Container(
          width: double.infinity,
          height: 0.5,
          color: fColor,
        ),
      ),
      itemCount: tasks.length,
    ),
  );
}
