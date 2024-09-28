import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const bucket = admin.storage().bucket();

export const uploadImage = functions.https.onRequest(async (req, res) => {
  try {
    // Verifica si el método es POST
    if (req.method !== "POST") {
      res.status(405).send("Método no permitido");
      return;
    }

    const file = req.body.file;
    const fileName = req.body.fileName;

    if (!file || !fileName) {
      res.status(400).send("Faltan parámetros: file o fileName");
      return;
    }

    const fileBuffer = Buffer.from(file, "base64");
    const fileUpload = bucket.file(fileName);
    await fileUpload.save(fileBuffer);

    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileUpload.name}`;

    await db.collection("photos").add({
      fileName: fileName,
      url: publicUrl,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).send({ message: "Imagen subida exitosamente", url: publicUrl });
  } catch (error) {
    console.error("Error al subir la imagen:", error);
    res.status(500).send("Error interno del servidor");
  }
});
