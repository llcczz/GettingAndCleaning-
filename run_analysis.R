library(dplyr)

calculate_stats <- function(metadata) {
    label <- metadata[1]
    file_name <- metadata[2]
    enable_stats <- metadata[3]
    data <- read.table(file_name, header=FALSE)
    if (enable_stats) {
        data_names <- names(data)
        lab_mean <- paste(label, "mean", sep="_")
        lab_sd <- paste(label, "sd", sep="_")
        data[lab_mean] <- rowMeans(subset(data, select = data_names), na.rm = TRUE)
        data[lab_sd] <- apply(subset(data, select = data_names), 1, sd)
        return(subset(data, select=c(lab_mean, lab_sd)))
    }
    names(data) <- label
    data
}

data_path <- file.path("data")
dataset_path <- file.path(data_path, "UCI HAR Dataset")
if (!file.exists("data")){
    dir.create(file.path("data"))
}
zip_path <- file.path(data_path, "dataset.zip")
if (!file.exists(zip_path)) {
    data_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(data_url, zip_path, method = "curl")
}
dataset_path <- file.path(data_path, "UCI HAR Dataset")
if (!file.exists(dataset_path)) {
    unzip(zip_path, exdir = dataset_path)
}

datafiles_path <- file.path("data_files")
if (!file.exists(datafiles_path)) {
    dir.create(datafiles_path)
    file_list <- list.files(dataset_path, recursive = TRUE, include.dirs = FALSE)
    file.copy(file.path(dataset_path, file_list), datafiles_path)
}
activity_labels <-  read.table(file.path(datafiles_path, "activity_labels.txt"), header=FALSE)
names(activity_labels) <- c("id", "activity")

measurement_meta = data.frame(measurement_names=c("subject", "y", "X", "body_acc_x", "body_acc_y", "body_acc_z", "body_gyro_x", "body_gyro_y", "body_gyro_z", "total_acc_x", "total_acc_y", "total_acc_z"))
measurement_meta$test_file_names <- file.path(datafiles_path, paste(measurement_meta$measurement_names, "test.txt", sep = "_"))
measurement_meta$train_file_names <- file.path(datafiles_path, paste(measurement_meta$measurement_names, "train.txt", sep = "_"))
measurement_meta$enable_stats <- ifelse(measurement_meta$measurement_names %in% c("subject", "y"), FALSE, TRUE)

test_data <- do.call(cbind, apply(measurement_meta[,c("measurement_names", "test_file_names", "enable_stats")], 1, calculate_stats))
train_data <- do.call(cbind, apply(measurement_meta[,c("measurement_names", "train_file_names", "enable_stats")], 1, calculate_stats))
measurements <- rbind(test_data, train_data) %>% as_tibble() %>% merge(activity_labels, by.x="y", by.y="id", all = TRUE)
tidy <- measurements %>%
    group_by(subject, activity) %>%
    summarise(
        X = mean(X_mean),
        body_acc_x = mean(body_acc_x_mean),
        body_acc_y = mean(body_acc_y_mean),
        body_acc_z = mean(body_acc_z_mean),
        body_gyro_x = mean(body_gyro_x_mean),
        body_gyro_y = mean(body_gyro_y_mean),
        body_gyro_z = mean(body_gyro_z_mean),
        total_acc_x = mean(total_acc_x_mean),
        total_acc_y = mean(total_acc_y_mean),
        total_acc_z = mean(total_acc_z_mean),
    )

write.table(tidy, file="tidy.txt", row.name = FALSE)



