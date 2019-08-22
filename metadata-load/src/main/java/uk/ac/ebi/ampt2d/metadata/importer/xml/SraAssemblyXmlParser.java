/*
 *
 * Copyright 2019 EMBL - European Bioinformatics Institute
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package uk.ac.ebi.ampt2d.metadata.importer.xml;

import org.apache.xmlbeans.XmlException;
import uk.ac.ebi.ena.sra.xml.ASSEMBLYDocument;
import uk.ac.ebi.ena.sra.xml.AssemblyType;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SraAssemblyXmlParser extends SraXmlParser<AssemblyType> {

    private static final Logger LOGGER = Logger.getLogger(SraAssemblyXmlParser.class.getName());

    @Override
    public AssemblyType parseXml(String xmlString, String accession) throws XmlException {
        xmlString = removeRootTagsFromXmlString(xmlString); // For API calls
        xmlString = removeSetTagsFromXmlString(xmlString); // For database queries
        try {
            return ASSEMBLYDocument.Factory.parse(xmlString).getASSEMBLY();
        } catch (XmlException e) {
            LOGGER.log(Level.SEVERE, "An error occurred while parsing XML for accession " + accession);
            throw e;
        }
    }

}
