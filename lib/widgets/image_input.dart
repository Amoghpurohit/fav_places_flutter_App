import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget{
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage; //passing fucntion as a value here as we need to pass the image to this function

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput>{

  File? _selectedImage;

  void _takePicture() async {
    final imagepicker = ImagePicker();
    final pickedImage = await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600, imageQuality: 70);  //pick image from source(camera or gallery) is a future of type XFile? as it could be null

    if(pickedImage == null){
      return;
    }
    setState(() {
      
      _selectedImage = File(pickedImage.path);  //Converting XFile to File as pickImage is of Type XFile,and get access to selectedimage with image value
    });

    widget.onPickImage(_selectedImage!);   //passing the selected image so that the image we get in the parent widget is also the selected image and we can have access to it there
  }



  @override
  Widget build(BuildContext context){

    Widget content = 
      TextButton.icon(
        label: const Text('Take Picture'),
        icon: const Icon(Icons.camera),
        onPressed: _takePicture,);

    if(_selectedImage != null){
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(_selectedImage!, fit: BoxFit.cover,width: double.infinity,height: double.infinity,)); //if selected image by user is not null then we will build the image using Image.file()
    } //built image should take all the horizontal space within the container.


    return Container(
      height: 250,
      width: double.infinity,      //takes up all the space horizontally
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.white),
      ),   //keeps the child in the center of the container
      child: content,     
      );
  }
}