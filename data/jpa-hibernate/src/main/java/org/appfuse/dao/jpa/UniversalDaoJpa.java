package org.appfuse.dao.jpa;

import java.io.Serializable;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityNotFoundException;
import javax.persistence.PersistenceContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.appfuse.dao.UniversalDao;

/**
 * This class serves as the a class that can CRUD any object witout any
 * Spring configuration. The only downside is it does require casting
 * from Object to the object class.
 *
 * @author Bryan Noll
 */
public class UniversalDaoJpa implements UniversalDao {
    protected final Log log = LogFactory.getLog(getClass());
    
    protected EntityManager entityManager;
    
    @PersistenceContext(unitName="ApplicationEntityManager")
    public void setEntityManager(EntityManager entityManager) {
      this.entityManager = entityManager;
    }

    /**
     * @see org.appfuse.dao.UniversalDao#save(java.lang.Object)
     */
    public void save(Object o) {
        Object objId = DaoUtils.getPersistentId(o);
        
        if (objId == null) {
            this.entityManager.persist(o);
        } else {
            this.entityManager.merge(o);
        }
    }

    /**
     * @see org.appfuse.dao.UniversalDao#get(java.lang.Class, java.io.Serializable)
     */
    public Object get(Class clazz, Serializable id) {
        Object o = this.entityManager.find(clazz, id);

        if (o == null) {
            String msg = "Uh oh, '" + clazz + "' object with id '" + id + "' not found..."; 
            log.warn(msg);
            throw new EntityNotFoundException(msg);
        }

        return o;
    }

    /**
     * @see org.appfuse.dao.UniversalDao#getAll(java.lang.Class)
     */
    public List getAll(Class clazz) {
        return this.entityManager.createQuery(
                "select obj from " + clazz + " obj").getResultList();
    }

    /**
     * @see org.appfuse.dao.UniversalDao#remove(java.lang.Class, java.io.Serializable)
     */
    public void remove(Class clazz, Serializable id) {
        this.entityManager.remove(this.get(clazz, id));
    }
}