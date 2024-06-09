CREATE TABLE `zonasentorno` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `message` TEXT NOT NULL,
    `coords` VARCHAR(255) NOT NULL,
    `radius` FLOAT NOT NULL,
    `notification_type` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`id`)
);