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

package uk.ac.ebi.ampt2d.metadata.importer.objects;

import uk.ac.ebi.ampt2d.metadata.importer.objectImporters.ObjectsImporter;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.Analysis;

import java.util.List;
import java.util.Set;

public class AnalysisObject implements ObjectToImport<AnalysisObject> {

    private Set<String> accessions;

    private List<Analysis> analyses;

    public Set<String> getAccessions() {
        return accessions;
    }

    public void setAccessions(Set<String> accessions) {
        this.accessions = accessions;
    }

    public List<Analysis> getAnalyses() {
        return analyses;
    }

    public void setAnalyses(List<Analysis> analyses) {
        this.analyses = analyses;
    }

    @Override
    public AnalysisObject doImport(ObjectsImporter objectsImporter) {
        return objectsImporter.importObject(this);
    }
}
