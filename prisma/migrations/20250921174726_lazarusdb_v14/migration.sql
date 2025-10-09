-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');

-- CreateEnum
CREATE TYPE "PatientStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DISCHARGED', 'TRANSFERRED');

-- CreateEnum
CREATE TYPE "ValidationStatus" AS ENUM ('PENDING', 'VALIDATED', 'REJECTED');

-- CreateEnum
CREATE TYPE "AccommodationType" AS ENUM ('STANDARD', 'PREMIUM', 'VIP', 'ICU');

-- CreateEnum
CREATE TYPE "AccommodationStatus" AS ENUM ('OCCUPIED', 'AVAILABLE', 'MAINTENANCE', 'RESERVED');

-- CreateEnum
CREATE TYPE "ProcedureStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "BillingStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'PAID');

-- CreateEnum
CREATE TYPE "AuditLogAction" AS ENUM ('CREATE', 'UPDATE', 'DELETE', 'VIEW', 'APPROVE', 'REJECT');

-- CreateEnum
CREATE TYPE "AuditLogEntity" AS ENUM ('PATIENT', 'PROCEDURE', 'BILLING', 'DOCUMENT', 'USER');

-- CreateEnum
CREATE TYPE "DocumentCategory" AS ENUM ('MEDICAL_RECORD', 'INSURANCE', 'IDENTIFICATION', 'PROCEDURE_REPORT', 'BILLING_DOCUMENT', 'OTHER');

-- CreateEnum
CREATE TYPE "BusinessRuleType" AS ENUM ('VALIDATION', 'CALCULATION', 'WORKFLOW', 'NOTIFICATION');

-- CreateEnum
CREATE TYPE "RuleStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DRAFT');

-- CreateTable
CREATE TABLE "patients" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "fullName" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "rg" TEXT NOT NULL,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "gender" "Gender" NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "medicalRecordNumber" TEXT NOT NULL,
    "admissionDate" TIMESTAMP(3) NOT NULL,
    "roomNumber" TEXT NOT NULL,
    "responsibleDoctor" TEXT NOT NULL,
    "insurancePlan" TEXT NOT NULL,
    "insuranceNumber" TEXT NOT NULL,
    "insuranceValidity" TIMESTAMP(3) NOT NULL,
    "accommodationType" "AccommodationType" NOT NULL,
    "currentAccommodation" "AccommodationType" NOT NULL,
    "accommodationStatus" "AccommodationStatus" NOT NULL,
    "observations" TEXT,
    "status" "PatientStatus" NOT NULL,
    "validationStatus" "ValidationStatus" NOT NULL,

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procedures" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "category" TEXT NOT NULL,
    "subcategory" TEXT,
    "complexity" TEXT NOT NULL,
    "estimatedDuration" INTEGER NOT NULL,
    "basePrice" DECIMAL(10,2) NOT NULL,
    "status" "ProcedureStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "patientId" TEXT,
    "requiresAuthorization" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "tags" TEXT[],

    CONSTRAINT "procedures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "billing_accounts" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "accountNumber" TEXT NOT NULL,
    "totalAmount" DECIMAL(10,2) NOT NULL,
    "paidAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "remainingAmount" DECIMAL(10,2) NOT NULL,
    "status" "BillingStatus" NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "billing_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "billing_items" (
    "id" TEXT NOT NULL,
    "billingAccountId" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "procedureId" TEXT,
    "description" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "unitPrice" DECIMAL(10,2) NOT NULL,
    "totalPrice" DECIMAL(10,2) NOT NULL,
    "discount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "status" "BillingStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "billing_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "action" "AuditLogAction" NOT NULL,
    "entity" "AuditLogEntity" NOT NULL,
    "entityId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "userName" TEXT NOT NULL,
    "userRole" TEXT NOT NULL,
    "oldValues" JSONB,
    "newValues" JSONB,
    "changes" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "sessionId" TEXT,
    "patientId" TEXT,
    "procedureId" TEXT,
    "billingAccountId" TEXT,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "filename" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "category" "DocumentCategory" NOT NULL,
    "subcategory" TEXT,
    "tags" TEXT[],
    "content" TEXT,
    "summary" TEXT,
    "patientId" TEXT,
    "isProcessed" BOOLEAN NOT NULL DEFAULT false,
    "isPublic" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_rules" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "code" TEXT NOT NULL,
    "type" "BusinessRuleType" NOT NULL,
    "status" "RuleStatus" NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "conditions" JSONB NOT NULL,
    "actions" JSONB NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "tags" TEXT[],

    CONSTRAINT "business_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dialogues" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "patientId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isResolved" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "tags" TEXT[],

    CONSTRAINT "dialogues_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_agents" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL,
    "config" JSONB NOT NULL,
    "model" TEXT NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isTraining" BOOLEAN NOT NULL DEFAULT false,
    "tags" TEXT[],

    CONSTRAINT "ai_agents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospital_systems" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "endpoint" TEXT NOT NULL,
    "apiKey" TEXT,
    "config" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isConnected" BOOLEAN NOT NULL DEFAULT false,
    "lastSync" TIMESTAMP(3),
    "version" TEXT NOT NULL DEFAULT '1.0',
    "tags" TEXT[],

    CONSTRAINT "hospital_systems_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "patients_cpf_key" ON "patients"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "patients_medicalRecordNumber_key" ON "patients"("medicalRecordNumber");

-- CreateIndex
CREATE INDEX "patients_cpf_idx" ON "patients"("cpf");

-- CreateIndex
CREATE INDEX "patients_medicalRecordNumber_idx" ON "patients"("medicalRecordNumber");

-- CreateIndex
CREATE INDEX "patients_roomNumber_idx" ON "patients"("roomNumber");

-- CreateIndex
CREATE INDEX "patients_status_idx" ON "patients"("status");

-- CreateIndex
CREATE INDEX "patients_validationStatus_idx" ON "patients"("validationStatus");

-- CreateIndex
CREATE UNIQUE INDEX "procedures_code_key" ON "procedures"("code");

-- CreateIndex
CREATE INDEX "procedures_code_idx" ON "procedures"("code");

-- CreateIndex
CREATE INDEX "procedures_category_idx" ON "procedures"("category");

-- CreateIndex
CREATE INDEX "procedures_status_idx" ON "procedures"("status");

-- CreateIndex
CREATE INDEX "procedures_patientId_idx" ON "procedures"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "billing_accounts_accountNumber_key" ON "billing_accounts"("accountNumber");

-- CreateIndex
CREATE INDEX "billing_accounts_patientId_idx" ON "billing_accounts"("patientId");

-- CreateIndex
CREATE INDEX "billing_accounts_accountNumber_idx" ON "billing_accounts"("accountNumber");

-- CreateIndex
CREATE INDEX "billing_accounts_status_idx" ON "billing_accounts"("status");

-- CreateIndex
CREATE INDEX "billing_items_billingAccountId_idx" ON "billing_items"("billingAccountId");

-- CreateIndex
CREATE INDEX "billing_items_patientId_idx" ON "billing_items"("patientId");

-- CreateIndex
CREATE INDEX "billing_items_procedureId_idx" ON "billing_items"("procedureId");

-- CreateIndex
CREATE INDEX "audit_logs_action_idx" ON "audit_logs"("action");

-- CreateIndex
CREATE INDEX "audit_logs_entity_idx" ON "audit_logs"("entity");

-- CreateIndex
CREATE INDEX "audit_logs_entityId_idx" ON "audit_logs"("entityId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "audit_logs"("userId");

-- CreateIndex
CREATE INDEX "audit_logs_createdAt_idx" ON "audit_logs"("createdAt");

-- CreateIndex
CREATE INDEX "audit_logs_patientId_idx" ON "audit_logs"("patientId");

-- CreateIndex
CREATE INDEX "documents_category_idx" ON "documents"("category");

-- CreateIndex
CREATE INDEX "documents_patientId_idx" ON "documents"("patientId");

-- CreateIndex
CREATE INDEX "documents_createdAt_idx" ON "documents"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "business_rules_code_key" ON "business_rules"("code");

-- CreateIndex
CREATE INDEX "business_rules_code_idx" ON "business_rules"("code");

-- CreateIndex
CREATE INDEX "business_rules_type_idx" ON "business_rules"("type");

-- CreateIndex
CREATE INDEX "business_rules_status_idx" ON "business_rules"("status");

-- CreateIndex
CREATE INDEX "business_rules_isActive_idx" ON "business_rules"("isActive");

-- CreateIndex
CREATE INDEX "dialogues_patientId_idx" ON "dialogues"("patientId");

-- CreateIndex
CREATE INDEX "dialogues_type_idx" ON "dialogues"("type");

-- CreateIndex
CREATE INDEX "dialogues_isActive_idx" ON "dialogues"("isActive");

-- CreateIndex
CREATE INDEX "ai_agents_type_idx" ON "ai_agents"("type");

-- CreateIndex
CREATE INDEX "ai_agents_isActive_idx" ON "ai_agents"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "hospital_systems_code_key" ON "hospital_systems"("code");

-- CreateIndex
CREATE INDEX "hospital_systems_code_idx" ON "hospital_systems"("code");

-- CreateIndex
CREATE INDEX "hospital_systems_isActive_idx" ON "hospital_systems"("isActive");

-- AddForeignKey
ALTER TABLE "procedures" ADD CONSTRAINT "procedures_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_accounts" ADD CONSTRAINT "billing_accounts_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_items" ADD CONSTRAINT "billing_items_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_items" ADD CONSTRAINT "billing_items_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_items" ADD CONSTRAINT "billing_items_procedureId_fkey" FOREIGN KEY ("procedureId") REFERENCES "procedures"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_procedureId_fkey" FOREIGN KEY ("procedureId") REFERENCES "procedures"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dialogues" ADD CONSTRAINT "dialogues_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
