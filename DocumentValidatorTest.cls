/**
* @author: Flavio Melo
* @email: flaviomelo17@gmail.com
* @date: 2024-06-24
*/

@isTest
public class DocumentValidatorTest {    
    @isTest
    static void testAccountTrigger() {
        // Obter IDs dos tipos de registro
        Id pessoaFisicaRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        Id pessoaJuridicaRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Jurídica').getRecordTypeId();
        
        // Teste de criação de conta com CPF válido
        Account pessoaFisica = new Account(RecordTypeId = pessoaFisicaRecordTypeId, Name = 'Teste Pessoa Física', CPF__c = '12345678909');
        insert pessoaFisica;
        pessoaFisica = [SELECT CPF__c FROM Account WHERE Id = :pessoaFisica.Id];
        System.assertEquals('12345678909', pessoaFisica.CPF__c);
        
        // Teste de criação de conta com CPF inválido
        Account pessoaFisicaInvalida = new Account(RecordTypeId = pessoaFisicaRecordTypeId, Name = 'Teste Pessoa Física Invalida', CPF__c = '12345678900');
        try {
            insert pessoaFisicaInvalida;
            System.assert(false, 'Expected exception for invalid CPF');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
        
        // Teste de criação de conta com CNPJ válido
        Account pessoaJuridica = new Account(RecordTypeId = pessoaJuridicaRecordTypeId, Name = 'Teste Pessoa Jurídica', CNPJ__c = '12345678000195');
        insert pessoaJuridica;
        pessoaJuridica = [SELECT CNPJ__c FROM Account WHERE Id = :pessoaJuridica.Id];
        System.assertEquals('12345678000195', pessoaJuridica.CNPJ__c);
        
        // Teste de atualização de conta com CPF válido para inválido
        pessoaFisica.CPF__c = '12345678900';
        try {
            update pessoaFisica;
            System.assert(false, 'Expected exception for invalid CPF');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }

        // Teste de atualização de conta com CNPJ válido para inválido
        pessoaJuridica.CNPJ__c = '12345678000100';
        try {
            update pessoaJuridica;
            System.assert(false, 'Expected exception for invalid CNPJ');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
        
        // Teste de criação de conta com CNPJ inválido
        Account pessoaJuridicaInvalida = new Account(RecordTypeId = pessoaJuridicaRecordTypeId, Name = 'Teste Pessoa Jurídica Invalida', CNPJ__c = '12345678000100');
        try {
            insert pessoaJuridicaInvalida;
            System.assert(false, 'Expected exception for invalid CNPJ');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
    }
    
    @isTest
    static void testLeadTrigger() {
        // Obter IDs dos tipos de registro
        Id pessoaFisicaRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        Id pessoaJuridicaRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Pessoa Jurídica').getRecordTypeId();
        
        // Teste de criação de lead com CPF válido
        Lead pessoaFisica = new Lead(RecordTypeId = pessoaFisicaRecordTypeId, LastName = 'Teste Pessoa Física', Company = 'Teste', CPF__c = '12345678909');
        insert pessoaFisica;
        pessoaFisica = [SELECT CPF__c FROM Lead WHERE Id = :pessoaFisica.Id];
        System.assertEquals('12345678909', pessoaFisica.CPF__c);
        
        // Teste de criação de lead com CPF inválido
        Lead pessoaFisicaInvalida = new Lead(RecordTypeId = pessoaFisicaRecordTypeId, LastName = 'Teste Pessoa Física Invalida', Company = 'Teste', CPF__c = '12345678900');
        try {
            insert pessoaFisicaInvalida;
            System.assert(false, 'Expected exception for invalid CPF');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
        
        // Teste de criação de lead com CNPJ válido
        Lead pessoaJuridica = new Lead(RecordTypeId = pessoaJuridicaRecordTypeId, LastName = 'Teste Pessoa Jurídica', Company = 'Teste', CNPJ__c = '12345678000195');
        insert pessoaJuridica;
        pessoaJuridica = [SELECT CNPJ__c FROM Lead WHERE Id = :pessoaJuridica.Id];
        System.assertEquals('12345678000195', pessoaJuridica.CNPJ__c);
        
        // Teste de criação de lead com CNPJ inválido
        Lead pessoaJuridicaInvalida = new Lead(RecordTypeId = pessoaJuridicaRecordTypeId, LastName = 'Teste Pessoa Jurídica Invalida', Company = 'Teste', CNPJ__c = '12345678000100');
        try {
            insert pessoaJuridicaInvalida;
            System.assert(false, 'Expected exception for invalid CNPJ');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
        
        // Teste de atualização de lead com CPF válido para inválido
        pessoaFisica.CPF__c = '12345678900';
        try {
            update pessoaFisica;
            System.assert(false, 'Expected exception for invalid CPF');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }

        // Teste de atualização de lead com CNPJ válido para inválido
        pessoaJuridica.CNPJ__c = '12345678000100';
        try {
            update pessoaJuridica;
            System.assert(false, 'Expected exception for invalid CNPJ');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Documento Inválido.'));
        }
    }
}