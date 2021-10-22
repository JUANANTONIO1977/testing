
## Cargo libreria dplyr

library(dplyr)

## Bajo dataset y descomprimo

Nombre <- "Trabajo_Final.zip"


if (!file.exists(Nombre)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, Nombre, method="curl")
}  


if (!file.exists("UCI HAR Dataset")) { 
  unzip(Nombre) 
}

## Coloco información en Dataframes

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_lavels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## punto 1- Fusiona los conjuntos de entrenamiento y prueba para crear un conjunto de datos

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

Subject <- rbind(subject_train, subject_test)

fusion <- cbind(Subject, Y, X)

## punto 2- Extrae solo las medidas de la media y la desviación estándar de cada medida

medidas <- fusion %>% select(subject, code, contains("mean"), contains("std"))

## punto 3- Utiliza nombres de actividades descriptivos para nombrar las actividades en el conjunto de datos

codigo_medidas <- activity_lavels[medidas$code, 2]

## punto 4- Etiqueta apropiadamente el conjunto de datos con nombres de variables descriptivos

head(medidas)

names(medidas)[2] = "activity"
names(medidas)<-gsub("Acc", "Accelerometro", names(medidas))
names(medidas)<-gsub("Gyro", "Gyroscopio", names(medidas))
names(medidas)<-gsub("BodyBody", "Body", names(medidas))
names(medidas)<-gsub("Mag", "Magnitud", names(medidas))
names(medidas)<-gsub("^t", "Tiempo", names(medidas))
names(medidas)<-gsub("^f", "Frequencia", names(medidas))
names(medidas)<-gsub("tBody", "TimeBody", names(medidas))
names(medidas)<-gsub("-mean()", "Media", names(medidas), ignore.case = TRUE)
names(medidas)<-gsub("-std()", "Desviacion_standar", names(medidas), ignore.case = TRUE)
names(medidas)<-gsub("-freq()", "Frequencia", names(medidas), ignore.case = TRUE)
names(medidas)<-gsub("angle", "Angulo", names(medidas))
names(medidas)<-gsub("gravity", "Gravedad", names(medidas))

## punto 5- A partir del conjunto de datos del paso 4, crea un segundo conjunto de datos ordenado e independiente con el promedio de cada variable para cada actividad y cada tema.

datos <- medidas %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(datos, "Data_Final_Getting_and_Cleaning_Data.txt", row.name=FALSE)





