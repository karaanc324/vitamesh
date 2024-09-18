import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new document with an auto-generated ID
  Future<String> addDocument(String collectionName, Map<String, dynamic> data,
      UserCredential userCred) async {
    try {
      final DocumentReference docRef =
          await _firestore.collection(collectionName).add(data);
      return docRef.id; // Return the auto-generated document ID
    } catch (e) {
      print('Error adding document: $e');
      return ''; // Or handle the error in a more appropriate way
    }
  }

  // Set data to a document with a specific ID
  Future<void> setDocument(String collectionName, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data);
    } catch (e) {
      print('Error setting document: $e');
    }
  }

  // Update data in an existing document
  Future<void> updateDocument(String collectionName, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Delete a document
  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String collectionName, String documentId) async {
    try {
      return await _firestore.collection(collectionName).doc(documentId).get();
    } catch (e) {
      print('Error getting document: $e');
      rethrow; // Rethrow the error to be handled by the caller
    }
  }

  // Get all documents from a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getDocuments(
      String collectionName) async {
    try {
      return await _firestore.collection(collectionName).get();
    } catch (e) {
      print('Error getting documents: $e');
      rethrow;
    }
  }

  // Get documents with a specific condition (query)
  // Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsByQuery(String collectionName, Query<Map<String, dynamic>> query) async {
  //   try {
  //     return await query.get();
  //   } catch (e) {
  //     print('Error getting documents by query: $e');
  //     rethrow;
  //   }
  // }

  Future<bool> documentExists(String collectionName, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(collectionName).doc(documentId).get();
      return documentSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false; // Or handle the error in a more appropriate way
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentsStream(
      String collectionName) {
    try {
      return _firestore.collection(collectionName).snapshots();
    } catch (e) {
      print('Error getting documents stream: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentsByQuery(
      collection, Map<String, dynamic> query) {
    try {
      return _firestore
          .collection(collection)
          .where(query.keys.first, isEqualTo: query.values.first)
          .snapshots();
    } catch (e) {
      print('Error getting documents by query: $e');
      rethrow;
    }
  }

  Future<String> uploadImageToFirebaseStorage(
      String filePath, String storageReference) async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      final storageRef = firebaseStorage.ref().child(storageReference);

      final file = File(filePath); // Replace with your actual file path
      final taskSnapshot = await storageRef.putFile(file);

      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Or throw a custom exception
    }
  }

  Future<String> getImageFromURL(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting image from URL: $e');
      return ''; // Or handle the error in a more appropriate way
    }
  }
}
