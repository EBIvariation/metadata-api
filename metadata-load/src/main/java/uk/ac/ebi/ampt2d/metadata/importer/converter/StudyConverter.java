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

package uk.ac.ebi.ampt2d.metadata.importer.converter;

import org.springframework.core.convert.converter.Converter;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.AccessionVersionId;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.Study;
import uk.ac.ebi.ena.sra.xml.AttributeType;
import uk.ac.ebi.ena.sra.xml.StudyType;

import java.time.LocalDate;

public class StudyConverter implements Converter<StudyType, Study> {

    @Override
    public Study convert(StudyType studyType) {
        StudyType.DESCRIPTOR studyDescriptor = studyType.getDESCRIPTOR();
        String studyAccession = studyType.getAccession();
        String studyName = studyDescriptor.getSTUDYTITLE().trim();
        String studyDescription = studyDescriptor.getSTUDYDESCRIPTION();
        studyDescription = (studyDescription == null) ? studyDescriptor.getSTUDYABSTRACT() : studyDescription;
        StudyType.STUDYATTRIBUTES studyattributes = studyType.getSTUDYATTRIBUTES();
        LocalDate studyReleaseDate = getReleaseDate(studyattributes);
        return new Study(new AccessionVersionId(studyAccession, 1), studyName,
                studyDescription, studyType.getCenterName(), studyReleaseDate);
    }

    private LocalDate getReleaseDate(StudyType.STUDYATTRIBUTES studyattributes) {
        LocalDate studyReleaseDate = LocalDate.of(9999, 12, 31);
        if (studyattributes == null) {
            return studyReleaseDate;
        }
        AttributeType[] studyattributesArray = studyattributes.getSTUDYATTRIBUTEArray();
        for (int i = 0; i < studyattributesArray.length; i++) {
            String attributeTag = studyattributesArray[i].getTAG();
            if (attributeTag.equals("ENA-FIRST-PUBLIC")) {
                studyReleaseDate = LocalDate.parse(studyattributesArray[i].getVALUE());
                break;
            }
        }
        return studyReleaseDate;
    }
}
