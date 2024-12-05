create database ClinicalTrial;
use ClinicalTrial;


-- Participant Table (General Entity)
CREATE TABLE Participant (
    ParticipantID VARCHAR(10) PRIMARY KEY,
    ParticipantFirstName VARCHAR(50),
    ParticipantLastName VARCHAR(50),
    Dob DATE,
    Gender VARCHAR(10),
    MedicalConditions TEXT,
    MedicationHistory TEXT,
    Allergies TEXT,
    BMI DECIMAL(5,2),
    ParticipantType VARCHAR(10) -- 'Adult' or 'Minor'
);

CREATE INDEX idx_ParticipantID ON Participant(ParticipantID);

-- Adult Participant Table (Specialized Entity)
CREATE TABLE AdultParticipant (
    ParticipantID VARCHAR(10) PRIMARY KEY,
    ConsentStatus VARCHAR(20), -- Additional attribute for Adult Participant
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID)
);

CREATE INDEX idx_AdultParticipantID ON AdultParticipant(ParticipantID);

-- Minor Participant Table (Specialized Entity)
CREATE TABLE MinorParticipant (
    ParticipantID VARCHAR(10) PRIMARY KEY,
    GuardianName VARCHAR(100), -- Additional attribute for Minor Participant
    GuardianContactInfo VARCHAR(50), -- Additional attribute for Minor Participant
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID)
);

CREATE INDEX idx_MinorParticipantID ON MinorParticipant(ParticipantID);

-- Trial Design Table
CREATE TABLE TrialDesign (
    TrialID VARCHAR(10) PRIMARY KEY,
    TrialName VARCHAR(255),
    Objective TEXT,
    Phase VARCHAR(5), -- Use VARCHAR instead of ENUM
    StartDate DATE,
    EndDate DATE,
    PrincipalInvestigatorID INT,
    Sponsor VARCHAR(255)
);

CREATE INDEX idx_TrialID ON TrialDesign(TrialID);

-- Interventional Trial Table (Specialized Entity)
CREATE TABLE InterventionalTrial (
    TrialID VARCHAR(10) PRIMARY KEY,
    InterventionType VARCHAR(50), -- Additional attribute for Interventional Trial
    FOREIGN KEY (TrialID) REFERENCES TrialDesign(TrialID)
);

CREATE INDEX idx_InterventionalTrialID ON InterventionalTrial(TrialID);

-- Observational Trial Table (Specialized Entity)
CREATE TABLE ObservationalTrial (
    TrialID VARCHAR(10) PRIMARY KEY,
    ObservationMethod VARCHAR(50), -- Additional attribute for Observational Trial
    FOREIGN KEY (TrialID) REFERENCES TrialDesign(TrialID)
);

CREATE INDEX idx_ObservationalTrialID ON ObservationalTrial(TrialID);

-- Participant Enrollment Table
CREATE TABLE ParticipantEnrollment (
    EnrollmentID VARCHAR(10) PRIMARY KEY,
    ParticipantID VARCHAR(10),
    TrialID VARCHAR(10),
    ConsentDate DATE,
    EligibilityStatus VARCHAR(20), -- Use VARCHAR instead of ENUM
    EnrollmentDate DATE,
    WithdrawalDate DATE,
    ReasonForWithdrawal TEXT
);

CREATE INDEX idx_ParticipantID ON ParticipantEnrollment(ParticipantID);
CREATE INDEX idx_TrialID ON ParticipantEnrollment(TrialID);

-- Principal Investigator Table
CREATE TABLE PrincipalInvestigator (
    PrincipalInvestigatorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(20),
    Institution VARCHAR(255),
    Department VARCHAR(255),
    Specialty VARCHAR(255),
    ExperienceYears INT
);

CREATE INDEX idx_PrincipalInvestigatorID ON PrincipalInvestigator(PrincipalInvestigatorID);

-- Conditions ID Table
CREATE TABLE ConditionsID (
    ConditionID VARCHAR(10) PRIMARY KEY,
    ParticipantID VARCHAR(10),
    ConditionName TEXT,
    Allergies TEXT,
    MedicationHistory TEXT
);

CREATE INDEX idx_ParticipantID ON ConditionsID(ParticipantID);

-- Adverse Events Table
CREATE TABLE AdverseEvents (
    EventID VARCHAR(10) PRIMARY KEY,
    ParticipantID VARCHAR(10),
    TrialID VARCHAR(10),
    DateReported DATE,
    Description TEXT,
    Severity VARCHAR(10), 
    ActionTaken TEXT,
    Outcome TEXT
);

CREATE INDEX idx_ParticipantID ON AdverseEvents(ParticipantID);
CREATE INDEX idx_TrialID ON AdverseEvents(TrialID);

-- Mild Adverse Event Table (Specialized Entity)
CREATE TABLE MildAdverseEvent (
    EventID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (EventID) REFERENCES AdverseEvents(EventID)
);

-- Moderate Adverse Event Table (Specialized Entity)
CREATE TABLE ModerateAdverseEvent (
    EventID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (EventID) REFERENCES AdverseEvents(EventID)
);

-- Severe Adverse Event Table (Specialized Entity)
CREATE TABLE SevereAdverseEvent (
    EventID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (EventID) REFERENCES AdverseEvents(EventID)
);

-- Statistical Analysis Table
CREATE TABLE StatisticalAnalysis (
    AnalysisID VARCHAR(10) PRIMARY KEY,
    TrialID VARCHAR(10),
    AnalysisType VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    MainFindings TEXT,
    Conclusion TEXT
);

CREATE INDEX idx_TrialID ON StatisticalAnalysis(TrialID);








--Procedures and Triggers

-- Stored procedure for adding data to Participant table
CREATE or alter PROCEDURE AddParticipant 
    @ParticipantID VARCHAR(10),
    @ParticipantFirstName VARCHAR(50),
    @ParticipantLastName VARCHAR(50),
    @Dob DATE,
    @Gender VARCHAR(10),
    @MedicalConditions TEXT,
    @MedicationHistory TEXT,
    @Allergies TEXT,
    @BMI DECIMAL(5,2),
    @ParticipantType VARCHAR(10)
AS
BEGIN
    INSERT INTO Participant (ParticipantID, ParticipantFirstName, ParticipantLastName, Dob, Gender, MedicalConditions, MedicationHistory, Allergies, BMI, ParticipantType)
    VALUES (@ParticipantID, @ParticipantFirstName, @ParticipantLastName, @Dob, @Gender, @MedicalConditions, @MedicationHistory, @Allergies, @BMI, @ParticipantType);
END;
GO

-- Stored procedure for adding data to AdultParticipant table
CREATE or alter PROCEDURE AddAdultParticipant 
    @ParticipantID VARCHAR(10),
    @ConsentStatus VARCHAR(20)
AS
BEGIN
    INSERT INTO AdultParticipant (ParticipantID, ConsentStatus)
    VALUES (@ParticipantID, @ConsentStatus);
END;
GO

-- Stored procedure for adding data to MinorParticipant table
CREATE or alter PROCEDURE AddMinorParticipant 
    @ParticipantID VARCHAR(10),
    @GuardianName VARCHAR(100),
    @GuardianContactInfo VARCHAR(50)
AS
BEGIN
    INSERT INTO MinorParticipant (ParticipantID, GuardianName, GuardianContactInfo)
    VALUES (@ParticipantID, @GuardianName, @GuardianContactInfo);
END;
GO

-- Stored procedure for adding data to TrialDesign table
CREATE or alter PROCEDURE AddTrialDesign 
    @TrialID VARCHAR(10),
    @TrialName VARCHAR(255),
    @Objective TEXT,
    @Phase VARCHAR(5),
    @StartDate DATE,
    @EndDate DATE,
    @PrincipalInvestigatorID INT,
    @Sponsor VARCHAR(255)
AS
BEGIN
    INSERT INTO TrialDesign (TrialID, TrialName, Objective, Phase, StartDate, EndDate, PrincipalInvestigatorID, Sponsor)
    VALUES (@TrialID, @TrialName, @Objective, @Phase, @StartDate, @EndDate, @PrincipalInvestigatorID, @Sponsor);
END;
GO

-- Stored procedure for adding data to InterventionalTrial table
CREATE or alter PROCEDURE AddInterventionalTrial 
    @TrialID VARCHAR(10),
    @InterventionType VARCHAR(50)
AS
BEGIN
    INSERT INTO InterventionalTrial (TrialID, InterventionType)
    VALUES (@TrialID, @InterventionType);
END;
GO

-- Stored procedure for adding data to ObservationalTrial table
CREATE or alter PROCEDURE AddObservationalTrial 
    @TrialID VARCHAR(10),
    @ObservationMethod VARCHAR(50)
AS
BEGIN
    INSERT INTO ObservationalTrial (TrialID, ObservationMethod)
    VALUES (@TrialID, @ObservationMethod);
END;
GO

-- Stored procedure for adding data to ParticipantEnrollment table
CREATE or alter PROCEDURE AddParticipantEnrollment 
    @EnrollmentID VARCHAR(10),
    @ParticipantID VARCHAR(10),
    @TrialID VARCHAR(10),
    @ConsentDate DATE,
    @EligibilityStatus VARCHAR(20),
    @EnrollmentDate DATE,
    @WithdrawalDate DATE,
    @ReasonForWithdrawal TEXT
AS
BEGIN
    INSERT INTO ParticipantEnrollment (EnrollmentID, ParticipantID, TrialID, ConsentDate, EligibilityStatus, EnrollmentDate, WithdrawalDate, ReasonForWithdrawal)
    VALUES (@EnrollmentID, @ParticipantID, @TrialID, @ConsentDate, @EligibilityStatus, @EnrollmentDate, @WithdrawalDate, @ReasonForWithdrawal);
END;
GO

-- Stored procedure for adding data to PrincipalInvestigator table
CREATE or alter PROCEDURE AddPrincipalInvestigator 
    @PrincipalInvestigatorID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(50),
    @Phone VARCHAR(20),
    @Institution VARCHAR(255),
    @Department VARCHAR(255),
    @Specialty VARCHAR(255),
    @ExperienceYears INT
AS
BEGIN
    INSERT INTO PrincipalInvestigator (PrincipalInvestigatorID, FirstName, LastName, Email, Phone, Institution, Department, Specialty, ExperienceYears)
    VALUES (@PrincipalInvestigatorID, @FirstName, @LastName, @Email, @Phone, @Institution, @Department, @Specialty, @ExperienceYears);
END;
GO

-- Stored procedure for adding data to ConditionsID table
CREATE or alter PROCEDURE AddConditionsID 
    @ConditionID VARCHAR(10),
    @ParticipantID VARCHAR(10),
    @ConditionName TEXT,
    @Allergies TEXT,
    @MedicationHistory TEXT
AS
BEGIN
    INSERT INTO ConditionsID (ConditionID, ParticipantID, ConditionName, Allergies, MedicationHistory)
    VALUES (@ConditionID, @ParticipantID, @ConditionName, @Allergies, @MedicationHistory);
END;
GO

-- Stored procedure for adding data to AdverseEvents table
CREATE or alter PROCEDURE AddAdverseEvents 
    @EventID VARCHAR(10),
    @ParticipantID VARCHAR(10),
    @TrialID VARCHAR(10),
    @DateReported DATE,
    @Description TEXT,
    @Severity VARCHAR(10), 
    @ActionTaken TEXT,
    @Outcome TEXT
AS
BEGIN
    INSERT INTO AdverseEvents (EventID, ParticipantID, TrialID, DateReported, Description, Severity, ActionTaken, Outcome)
    VALUES (@EventID, @ParticipantID, @TrialID, @DateReported, @Description, @Severity, @ActionTaken, @Outcome);
END;
GO

-- Stored procedure for adding data to MildAdverseEvent table
CREATE or alter PROCEDURE AddMildAdverseEvent 
    @EventID VARCHAR(10)
AS
BEGIN
    INSERT INTO MildAdverseEvent (EventID)
    VALUES (@EventID);
END;
GO

-- Stored procedure for adding data to ModerateAdverseEvent table
CREATE or alter PROCEDURE AddModerateAdverseEvent 
    @EventID VARCHAR(10)
AS
BEGIN
    INSERT INTO ModerateAdverseEvent (EventID)
    VALUES (@EventID);
END;
GO

-- Stored procedure for adding data to SevereAdverseEvent table
CREATE or alter PROCEDURE AddSevereAdverseEvent 
    @EventID VARCHAR(10)
AS
BEGIN
    INSERT INTO SevereAdverseEvent (EventID)
    VALUES (@EventID);
END;
GO

-- Stored procedure for adding data to StatisticalAnalysis table
CREATE or alter PROCEDURE AddStatisticalAnalysis 
    @AnalysisID VARCHAR(10),
    @TrialID VARCHAR(10),
    @AnalysisType VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @MainFindings TEXT,
    @Conclusion TEXT
AS
BEGIN
    INSERT INTO StatisticalAnalysis (AnalysisID, TrialID, AnalysisType, StartDate, EndDate, MainFindings, Conclusion)
    VALUES (@AnalysisID, @TrialID, @AnalysisType, @StartDate, @EndDate, @MainFindings, @Conclusion);
END;
GO



-- Sample data for Participant table
EXEC AddParticipant 'P001', 'John', 'Doe', '1990-05-15', 'Male', 'None', 'None', 'None', 24.5, 'Adult';
EXEC AddParticipant 'P002', 'Jane', 'Smith', '1995-08-20', 'Female', 'Asthma', 'None', 'Peanuts', 22.3, 'Adult';
EXEC AddParticipant 'P003', 'Michael', 'Johnson', '2005-03-10', 'Male', 'ADHD', 'Ritalin', 'None', 18.8, 'Minor';
EXEC AddParticipant 'P004', 'Emily', 'Brown', '2000-11-30', 'Female', 'None', 'None', 'Pollen', 20.1, 'Minor';
EXEC AddParticipant 'P005', 'David', 'Wilson', '1985-07-25', 'Male', 'Diabetes', 'Insulin', 'Penicillin', 28.9, 'Adult';

-- Sample data for AdultParticipant table
EXEC AddAdultParticipant 'P001', 'Consented';
EXEC AddAdultParticipant 'P002', 'Consented';
EXEC AddAdultParticipant 'P005', 'Consented';

-- Sample data for MinorParticipant table
EXEC AddMinorParticipant 'P003', 'Sarah Johnson', '123-456-7890';
EXEC AddMinorParticipant 'P004', 'Jennifer Brown', '987-654-3210';

-- Sample data for TrialDesign table
EXEC AddTrialDesign 'T001', 'COVID-19 Vaccine Trial', 'Evaluate the efficacy of a new COVID-19 vaccine.', 'Phase III', '2023-01-15', '2024-06-30', 101, 'ABC Pharmaceuticals';
EXEC AddTrialDesign 'T002', 'Pain Management Study', 'Assess the effectiveness of a new pain relief medication.', 'Phase II', '2024-03-10', '2025-12-31', 102, 'XYZ Biotech';

-- Sample data for InterventionalTrial table
EXEC AddInterventionalTrial 'T002', 'Medication';

-- Sample data for ObservationalTrial table
EXEC AddObservationalTrial 'T001', 'Longitudinal Study';

-- Sample data for ParticipantEnrollment table
EXEC AddParticipantEnrollment 'E001', 'P001', 'T001', '2023-01-20', 'Eligible', '2023-01-25', NULL, NULL;
EXEC AddParticipantEnrollment 'E002', 'P002', 'T001', '2023-01-22', 'Ineligible', '2023-01-25', '2023-02-10', 'High BMI';
EXEC AddParticipantEnrollment 'E003', 'P003', 'T002', '2024-03-15', 'Eligible', '2024-03-20', NULL, NULL;

-- Sample data for PrincipalInvestigator table
EXEC AddPrincipalInvestigator 101, 'Dr. Robert', 'Smith', 'robert.smith@example.com', '123-456-7890', 'University Hospital', 'Cardiology', 'Cardiologist', 15;
EXEC AddPrincipalInvestigator 102, 'Dr. Lisa', 'Johnson', 'lisa.johnson@example.com', '987-654-3210', 'City Clinic', 'Neurology', 'Neurologist', 12;

-- Sample data for ConditionsID table
EXEC AddConditionsID 'C001', 'P002', 'Asthma', 'Pollen', 'None';
EXEC AddConditionsID 'C002', 'P005', 'Diabetes', 'None', 'Insulin';

-- Sample data for AdverseEvents table
EXEC AddAdverseEvents 'AE001', 'P001', 'T001', '2023-02-02', 'Fever after vaccination', 'Mild', 'Rest and hydration', 'Resolved on its own';
EXEC AddAdverseEvents 'AE002', 'P002', 'T001', '2023-02-05', 'Allergic reaction to vaccine', 'Severe', 'Hospitalization and medication', 'Recovered after treatment';
EXEC AddAdverseEvents 'AE003', 'P003', 'T002', '2024-04-02', 'Dizziness after medication', 'Moderate', 'Reduced dosage', 'Resolved with dosage adjustment';

-- Sample data for MildAdverseEvent table
EXEC AddMildAdverseEvent 'AE001';

-- Sample data for ModerateAdverseEvent table
EXEC AddModerateAdverseEvent 'AE003';

-- Sample data for SevereAdverseEvent table
EXEC AddSevereAdverseEvent 'AE002';

-- Sample data for StatisticalAnalysis table
EXEC AddStatisticalAnalysis 'SA001', 'T001', 'Descriptive Analysis', '2024-07-01', '2024-07-15', 'Increased antibody response observed.', 'Promising results for vaccine efficacy.';
EXEC AddStatisticalAnalysis 'SA002', 'T002', 'Regression Analysis', '2025-01-01', '2025-01-15', 'Correlation between medication dosage and pain relief.', 'Further studies recommended.';


-- Select statements for all tables

-- Participant table
SELECT * FROM Participant;

-- AdultParticipant table
SELECT * FROM AdultParticipant;

-- MinorParticipant table
SELECT * FROM MinorParticipant;

-- TrialDesign table
SELECT * FROM TrialDesign;

-- InterventionalTrial table
SELECT * FROM InterventionalTrial;

-- ObservationalTrial table
SELECT * FROM ObservationalTrial;

-- ParticipantEnrollment table
SELECT * FROM ParticipantEnrollment;

-- PrincipalInvestigator table
SELECT * FROM PrincipalInvestigator;

-- ConditionsID table
SELECT * FROM ConditionsID;

-- AdverseEvents table
SELECT * FROM AdverseEvents;

-- MildAdverseEvent table
SELECT * FROM MildAdverseEvent;

-- ModerateAdverseEvent table
SELECT * FROM ModerateAdverseEvent;

-- SevereAdverseEvent table
SELECT * FROM SevereAdverseEvent;

-- StatisticalAnalysis table
SELECT * FROM StatisticalAnalysis;





-- Create the ParticipantChange table
CREATE TABLE ParticipantChange (
    ParticipantChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
    ParticipantID VARCHAR(10) NOT NULL,
    FieldName VARCHAR(100) NOT NULL,
    OldValue TEXT,
    NewValue TEXT,
    ChangeDate DATETIME NOT NULL,
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID)
);

-- Create trigger to track changes in the Participant table
CREATE TRIGGER ParticipantChangeTrigger
ON Participant
AFTER UPDATE
AS
BEGIN
    DECLARE @ParticipantID VARCHAR(10);
    SET @ParticipantID = (SELECT ParticipantID FROM INSERTED);

    IF (UPDATE(ParticipantFirstName)) -- Check if ParticipantFirstName is updated
    BEGIN
        INSERT INTO ParticipantChange (ParticipantChangeID, ParticipantID, FieldName, OldValue, NewValue, ChangeDate)
        SELECT 
            ISNULL((SELECT MAX(ParticipantChangeID)+1 FROM ParticipantChange), 1),
            @ParticipantID,
            'ParticipantFirstName',
            (SELECT ParticipantFirstName FROM DELETED),
            (SELECT ParticipantFirstName FROM INSERTED),
            GETDATE();
    END;

    IF (UPDATE(ParticipantLastName)) -- Check if ParticipantLastName is updated
    BEGIN
        INSERT INTO ParticipantChange (ParticipantChangeID, ParticipantID, FieldName, OldValue, NewValue, ChangeDate)
        SELECT 
            ISNULL((SELECT MAX(ParticipantChangeID)+1 FROM ParticipantChange), 1),
            @ParticipantID,
            'ParticipantLastName',
            (SELECT ParticipantLastName FROM DELETED),
            (SELECT ParticipantLastName FROM INSERTED),
            GETDATE();
    END;

   
END;




select * from Participant;

select * from ParticipantChange;

UPDATE PARTICIPANT 
SET ParticipantFirstName= 'Jon'
where ParticipantID = 'P001';


UPDATE PARTICIPANT 
SET ParticipantLastName= 'Snow'
where ParticipantID = 'P001';

select * from ParticipantChange;


--Questions/Queries that can be useful for management


SELECT TrialDesign.Phase, COUNT(ParticipantEnrollment.ParticipantID) AS ParticipantCount
FROM TrialDesign
INNER JOIN ParticipantEnrollment ON TrialDesign.TrialID = ParticipantEnrollment.TrialID
GROUP BY TrialDesign.Phase;




SELECT ConditionName, COUNT(DISTINCT ParticipantID) AS NumberOfParticipants
FROM ConditionsID
GROUP BY ConditionName
ORDER BY NumberOfParticipants DESC;

select * from ConditionsID;


SELECT CAST(ConditionName AS VARCHAR(MAX)) AS ConditionName, COUNT(DISTINCT ParticipantID) AS NumberOfParticipants
FROM ConditionsID
GROUP BY CAST(ConditionName AS VARCHAR(MAX))
ORDER BY NumberOfParticipants DESC;



SELECT TrialID, COUNT(*) AS NumberOfAdverseEvents
FROM AdverseEvents
GROUP BY TrialID
ORDER BY NumberOfAdverseEvents DESC;


SELECT TrialID, AVG(DATEDIFF(day, EnrollmentDate, WithdrawalDate)) AS AverageEnrollmentDuration
FROM ParticipantEnrollment
WHERE WithdrawalDate IS NOT NULL
GROUP BY TrialID;



SELECT CAST(ReasonForWithdrawal AS VARCHAR(MAX)) AS ReasonForWithdrawal, COUNT(*) AS Count
FROM ParticipantEnrollment
WHERE ReasonForWithdrawal IS NOT NULL
GROUP BY CAST(ReasonForWithdrawal AS VARCHAR(MAX))
ORDER BY Count DESC;
