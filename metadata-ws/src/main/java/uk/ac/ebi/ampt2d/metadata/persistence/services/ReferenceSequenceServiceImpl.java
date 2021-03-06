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
package uk.ac.ebi.ampt2d.metadata.persistence.services;

import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.QReferenceSequence;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.ReferenceSequence;
import uk.ac.ebi.ampt2d.metadata.persistence.repositories.ReferenceSequenceRepository;

import java.util.List;

public class ReferenceSequenceServiceImpl implements ReferenceSequenceService {

    @Autowired
    private ReferenceSequenceRepository referenceSequenceRepository;

    @Autowired
    private TaxonomyService taxonomyService;

    @Override
    public List<ReferenceSequence> findReferenceSequencesByTaxonomyId(long id) {
        List<Long> taxonomyIds = taxonomyService.findAllTaxonomiesInATreeByTaxonomyIds(id);
        return getReferenceSequences(taxonomyIds);
    }

    @Override
    public List<ReferenceSequence> findReferenceSequencesByTaxonomyName(String name) {
        List<Long> taxonomyIds = taxonomyService.findAllTaxonomiesInATreeByTaxonomyName(name);
        return getReferenceSequences(taxonomyIds);
    }

    public List<ReferenceSequence> getReferenceSequences(List<Long> taxonomyIds) {
        QReferenceSequence referenceSequence = QReferenceSequence.referenceSequence;
        Predicate predicate = referenceSequence.taxonomy.taxonomyId.in(taxonomyIds);
        return (List<ReferenceSequence>) referenceSequenceRepository.findAll(predicate);
    }
}
