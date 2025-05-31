-- Create SystemSettings table to store admin configurations
CREATE TABLE SystemSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingName NVARCHAR(100) NOT NULL UNIQUE,
    SettingValue NVARCHAR(500) NOT NULL,
    SettingDescription NVARCHAR(255) NULL,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Insert default system settings
INSERT INTO SystemSettings (SettingName, SettingValue, SettingDescription) VALUES
('SystemName', 'Bulb Learning Management System', 'The name displayed throughout the application'),
('MaxAssignmentPoints', '100', 'Default maximum points for new assignments'),
('AutoSaveFrequency', '10', 'How often user progress is automatically saved (minutes)'),
('AllowSelfRegistration', 'true', 'Enable users to register accounts themselves'),
('DefaultUserRole', 'Student', 'Default role assigned to new users'),
('PasswordMinLength', '8', 'Minimum characters required for passwords'),
('AllowLateSubmissions', 'true', 'Allow submissions after due date'),
('LatePenaltyPercent', '10', 'Points deducted for late submissions per day'),
('AutoGradeSubmissions', 'false', 'Automatically assign full points to submitted assignments'),
('EmailNotifications', 'true', 'Send email notifications for important events'),
('DueReminderDays', '3', 'Days before due date to send reminders'),
('GradeNotifications', 'true', 'Notify students when assignments are graded');

-- Create index for faster lookups
CREATE NONCLUSTERED INDEX IX_SystemSettings_SettingName ON SystemSettings (SettingName);