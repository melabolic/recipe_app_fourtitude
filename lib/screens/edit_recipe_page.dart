import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/recipe_item.dart';
import '../utils/recipes_provider.dart';

class EditRecipePage extends StatefulWidget {
  const EditRecipePage({super.key, required this.recipe});

  final RecipeItem recipe;

  static const routeName = '/editRecipe';

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _recipeTypeController;
  late Uint8List _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _ingredientsController = TextEditingController(
      text: widget.recipe.ingredients,
    );
    _stepsController = TextEditingController(text: widget.recipe.steps);
    _imagePath = widget.recipe.imagePath;
    _recipeTypeController = TextEditingController(
      text: widget.recipe.recipeType,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _recipeTypeController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Edit Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderImagePicker(
                      initialValue: [XFile.fromData(widget.recipe.imagePath)],
                      previewAutoSizeWidth: true,
                      transformImageWidget:
                          (context, displayImage) =>
                              SizedBox.expand(child: displayImage),
                      fit: BoxFit.fitWidth,
                      name: 'Recipe Photo',
                      showDecoration: true,
                      decoration: InputDecoration(border: InputBorder.none),
                      maxImages: 1,
                      onChanged: _onSelectPicture,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      bottomSheetPadding: EdgeInsets.fromLTRB(
                        12,
                        12,
                        12,
                        MediaQuery.of(context).viewPadding.bottom,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a picture.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Recipe Name',
                        labelText: 'Recipe Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter recipe\'s name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownMenu(
                      controller: _recipeTypeController,
                      width: double.infinity,
                      requestFocusOnTap: true,
                      label: Text('Recipe Type'),
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      dropdownMenuEntries:
                          context
                              .read<RecipesProvider>()
                              .recipeTypes
                              .map(
                                (e) => DropdownMenuEntry(
                                  value: e.id,
                                  label: e.type,
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _ingredientsController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Ingredients',
                        labelText: 'Ingredients',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the ingredients.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _stepsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Steps',
                        labelText: 'Steps',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the steps.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onUpdateRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.primary,
                  foregroundColor:
                      Theme.of(context).colorScheme.onInverseSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save Recipe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectPicture(List<dynamic>? images) async {
    if (images!.isNotEmpty) {
      final bytes = await (images.first as XFile).readAsBytes();
      _imagePath = bytes;
    } else {
      _imagePath = Uint8List(0);
    }
  }

  void _onUpdateRecipe() {
    final updatedRecipe = RecipeItem(
      id: widget.recipe.id,
      imagePath: _imagePath,
      title: _titleController.text.trim(),
      recipeType: _recipeTypeController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      steps: _stepsController.text.trim(),
    );
    context.read<RecipesProvider>().updateRecipe(updatedRecipe);
    context.pop(updatedRecipe);
  }
}
